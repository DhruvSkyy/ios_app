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
                    .frame(width: width, height: height)
            } else if loadFailed {
                // Show an error placeholder
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
                // Show a loading placeholder
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

            // Optionally preserve aspect ratio if needed:
            // svgImage.bbImporter?.preserveAspectRatio = .xMidYMid
            // svgImage.bbImporter?.meetOrSlice = .meet

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

            // Render the SVG into a UIImage at its intrinsic size
            let size = svgImage.size
            layer.frame = CGRect(origin: .zero, size: size)
            
            let renderer = UIGraphicsImageRenderer(size: size)
            let image = renderer.image { ctx in
                layer.render(in: ctx.cgContext)
            }

            DispatchQueue.main.async {
                self.uiImage = image
            }
        }.resume()
    }
}
