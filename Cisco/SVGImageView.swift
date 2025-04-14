import SwiftUI
import SVGKit

struct SVGImageView: View {
    let urlString: String
    @State private var uiImage: UIImage? = nil
    @State private var loadFailed = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else if loadFailed {
                    // Final fallback image
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray)

                        Image(systemName: "xmark.octagon.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                            .foregroundColor(.white)
                    }
                } else {
                    // Temporary loading view
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray)

                        Image(systemName: "xmark.octagon.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                            .foregroundColor(.white)
                    }
                        .onAppear {
                            loadSVGAsync(size: geometry.size)
                        }
                }
            }
        }
    }

    private func loadSVGAsync(size: CGSize) {
        guard size.width > 0, size.height > 0,
              !size.width.isNaN, !size.height.isNaN,
              let url = URL(string: urlString) else {
            self.loadFailed = true
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let data = data,
                  let svgImage = SVGKImage(data: data) else {
                DispatchQueue.main.async {
                    self.loadFailed = true
                }
                return
            }

            let scale = UIScreen.main.scale
            let targetSize = CGSize(width: size.width * scale, height: size.height * scale)
            svgImage.scaleToFit(inside: targetSize)

            guard svgImage.size.width > 0, svgImage.size.height > 0,
                  !svgImage.size.width.isNaN, !svgImage.size.height.isNaN,
                  let layer = svgImage.caLayerTree else {
                DispatchQueue.main.async {
                    self.loadFailed = true
                }
                return
            }

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
