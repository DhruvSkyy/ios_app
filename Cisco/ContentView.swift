import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WebsiteViewModel()
    @State private var isSorted = false

    var sortedWebsites: [Website] {
        isSorted ? viewModel.websites.sorted { $0.name < $1.name } : viewModel.websites
    }

    var body: some View {
        NavigationView {
            List(sortedWebsites) { website in
                HStack(alignment: .top, spacing: 12) {
                    AsyncImage(url: URL(string: website.icon ?? "")) { phase in
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

                    VStack(alignment: .leading, spacing: 4) {
                        Text(website.name)
                            .font(.headline)
                        Text(website.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(website.url)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Websites")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSorted.toggle()
                    }) {
                        Text(isSorted ? "Unsort" : "Sort A-Z")
                    }
                }
            }
            .onAppear {
                viewModel.fetchWebsites()
            }
        }
    }
}
