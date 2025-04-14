import SwiftUI
import SVGKit

struct SVGImageView: View {
    let urlString: String
    var width: CGFloat = 48
    var height: CGFloat = 48

    @State private var uiImage: UIImage? = nil
    @State private var loadFailed = false

    var body: some View {
        ZStack {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    // These two lines ensure the final SwiftUI image
                    // respects the bounding box without cropping:
                    .frame(width: width, height: height)
            } else if loadFailed {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray)
                    .overlay(
                        Image(systemName: "xmark.octagon.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .padding(8)
                    )
                    .frame(width: width, height: height)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                    )
                    .frame(width: width, height: height)
                    .onAppear {
                        loadSVGAsync()
                    }
            }
        }
        .cornerRadius(8)
    }

    private func loadSVGAsync() {
        guard let url = URL(string: urlString) else {
            self.loadFailed = true
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard
                error == nil,
                let data = data,
                let svgImage = SVGKImage(data: data)
            else {
                DispatchQueue.main.async {
                    self.loadFailed = true
                }
                return
            }

            // If needed, set preserveAspectRatio explicitly before scaling:
            // svgImage.bbImporter?.preserveAspectRatio = .xMidYMid
            // svgImage.bbImporter?.meetOrSlice = .meet

            // Remove *UIScreen.main.scale to avoid oversized frames that crop:
            svgImage.scaleToFit(inside: CGSize(width: width, height: height))

            guard
                svgImage.size.width > 0,
                svgImage.size.height > 0,
                let layer = svgImage.caLayerTree
            else {
                DispatchQueue.main.async {
                    self.loadFailed = true
                }
                return
            }

            // Draw the scaled layer into a UIImage:
            layer.frame = CGRect(origin: .zero, size: svgImage.size)
            let renderer = UIGraphicsImageRenderer(size: svgImage.size)
            let image = renderer.image { ctx in
                layer.render(in: ctx.cgContext)
            }

            DispatchQueue.main.async {
                self.uiImage = image
            }
        }.resume()
    }
}
