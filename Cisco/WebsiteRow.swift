//
//  WebsiteRow.swift
//  Cisco
//
//  Created by Dhruv Sharma on 14/04/2025.
//

import SwiftUI

struct WebsiteRow: View {
    let website: Website

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                if let iconURL = website.icon {
                    if iconURL.hasSuffix(".svg") {
                        SVGImageView(urlString: iconURL)
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                    } else {
                        AsyncImage(url: URL(string: iconURL)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(8)
                            } else if phase.error != nil {
                                Color.red
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(8)
                            } else {
                                ProgressView()
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                }


                VStack(alignment: .leading, spacing: 4) {
                    Text(website.name)
                        .font(.headline)
                    Text(website.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Tappable URL
                    if let url = URL(string: website.url) {
                        Link(website.url, destination: url)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .underline()
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
