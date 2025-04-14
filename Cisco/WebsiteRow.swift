import SwiftUI

struct WebsiteRow: View {
    let website: Website

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Consistent 48x48 icon
            Group {
                if let iconURL = website.icon {
                    if iconURL.hasSuffix(".svg") {
                        SVGImageView(urlString: iconURL, width: 48, height: 48)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                    } else {
                        AsyncImage(url: URL(string: iconURL)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } else if phase.error != nil {
                                Image(systemName: "globe")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.gray)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 48, height: 48)
                        .cornerRadius(8)
                        .clipped()
                    }
                } else {
                    Image(systemName: "globe")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .foregroundColor(.gray)
                        .cornerRadius(8)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(website.name)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(website.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                if let url = URL(string: website.url) {
                    Link(website.url, destination: url)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            }

            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .center) // Ensures uniform height
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
}
