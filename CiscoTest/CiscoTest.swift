import XCTest
@testable import website_browser

final class CiscoTests: XCTestCase {

    /// Tests that the `Website` model correctly decodes valid JSON.
    /// Verifies that each field is mapped as expected.
    func testWebsiteModelDecoding() {
        let json = """
        {
            "name": "Test Site",
            "url": "https://example.com",
            "icon": "https://example.com/icon.svg",
            "description": "A sample description"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        do {
            let website = try decoder.decode(Website.self, from: json)
            XCTAssertEqual(website.name, "Test Site")
            XCTAssertEqual(website.url, "https://example.com")
            XCTAssertEqual(website.icon, "https://example.com/icon.svg")
            XCTAssertEqual(website.description, "A sample description")
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }

    /// Tests that the `WebsiteViewModel` fetches and decodes data successfully
    /// when given a mocked session returning valid JSON.
    /// Asserts that the data is correctly published to the `websites` array.
    func testWebsiteViewModelFetchSuccess() {
        let expectation = XCTestExpectation(description: "Fetch websites")

        let mockData = """
        [
            {
                "name": "Mock Site",
                "url": "https://mock.com",
                "icon": null,
                "description": "Mock description"
            }
        ]
        """.data(using: .utf8)!

        let mockSession = MockURLSession(data: mockData)
        let viewModel = WebsiteViewModel(session: mockSession)

        viewModel.fetchWebsites()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(viewModel.websites.count, 1)
            XCTAssertEqual(viewModel.websites.first?.name, "Mock Site")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mocks

/// A fake URLSession that returns predefined data instead of performing a real network call.
/// Used to test the view model's behaviour in isolation.
final class MockURLSession: URLSessionProtocol {
    let data: Data?

    init(data: Data?) {
        self.data = data
    }

    func dataTask(
        with url: URL,
        completionHandler: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTask {
            completionHandler(self.data, nil, nil)
        }
    }
}

/// A fake URLSessionDataTask that simply runs a closure when `resume()` is called.
/// Used to simulate network responses.
final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let closure: @Sendable () -> Void

    init(closure: @Sendable @escaping () -> Void) {
        self.closure = closure
    }

    func resume() {
        closure()
    }
}
