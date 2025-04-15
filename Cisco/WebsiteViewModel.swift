//
//  WebsiteViewModel.swift
//  Cisco
//
//  Created by Dhruv Sharma on 10/04/2025.
//

import Foundation

// MARK: - Protocols to allow mocking URLSession for testing

/// Protocol to abstract URLSessionDataTask so we can inject a mock version in tests.
/// Only includes `resume()` since that's all the ViewModel uses.
protocol URLSessionDataTaskProtocol {
    func resume()
}

/// Make the real URLSessionDataTask conform to our protocol.
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

/// Protocol to abstract URLSession so we can inject a mock version.
/// Returns a task conforming to `URLSessionDataTaskProtocol` for flexibility.
protocol URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol
}

/// Make the real URLSession conform to our protocol.
/// We return the real data task, typecast to our abstract protocol.
extension URLSession: URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask)
    }
}

class WebsiteViewModel: ObservableObject {
    @Published var websites: [Website] = []

    // API source
    private let dataURL = URL(string: "https://gist.githubusercontent.com/davidjarvis-TE/414edf2b4e878ab7ba1bf6bb1291a89e/raw/7537d5a0a37120e4a7127cc8f65f5265e723ff7b/websites_info.json")!

    // Abstracted session (real or mock)
    private let session: URLSessionProtocol

    /// Use dependency injection to allow injecting a mock session in tests.
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    /// Fetches websites from remote JSON endpoint and decodes into model.
    func fetchWebsites() {
        session.dataTask(with: dataURL) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode([Website].self, from: data)
                    DispatchQueue.main.async {
                        self.websites = decoded
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
}
