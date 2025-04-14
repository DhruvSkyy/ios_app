//
//  WebsiteViewModel.swift
//  Cisco
//
//  Created by Dhruv Sharma on 10/04/2025.
//

// WebsiteViewModel.swift

import Foundation

class WebsiteViewModel: ObservableObject {
    @Published var websites: [Website] = []
    private let dataURL = URL(string: "https://gist.githubusercontent.com/davidjarvis-TE/414edf2b4e878ab7ba1bf6bb1291a89e/raw/7537d5a0a37120e4a7127cc8f65f5265e723ff7b/websites_info.json")!

    func fetchWebsites() {
        URLSession.shared.dataTask(with: dataURL) { data, response, error in
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
