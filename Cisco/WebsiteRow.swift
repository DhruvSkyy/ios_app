import SwiftUI

struct WebsiteRow: View {
    let website: Website

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Logo/Icon
            if let iconURL = website.icon {
                if iconURL.hasSuffix(".svg") {
                    SVGImageView(urlString: iconURL)
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                } else {
                    AsyncImage(url: URL(string: iconURL)) { phase in
                        if let image = phase.image {
                            image.resizable()
                        } else if phase.error != nil {
                            Color.red
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(website.name)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.white)

                Text(website.description)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.75))

                if let url = URL(string: website.url) {
                    Link("Visit site →", destination: url)
                        .font(.footnote.bold())
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
    }
}
