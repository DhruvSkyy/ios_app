import XCTest
@testable import Cisco

final class CiscoTests: XCTestCase {

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

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let closure: @Sendable () -> Void

    init(closure: @Sendable @escaping () -> Void) {
        self.closure = closure
    }

    func resume() {
        closure()
    }
}
