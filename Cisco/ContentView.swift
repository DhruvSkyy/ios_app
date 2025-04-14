import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var viewModel = WebsiteViewModel()
    @State private var isSorted = false
    @State private var searchText = ""

    var filteredWebsites: [Website] {
        let source = isSorted ? viewModel.websites.sorted(by: { $0.name < $1.name }) : viewModel.websites
        if searchText.isEmpty { return source }
        return source.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.url.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Spotify-style dark background
                LinearGradient(gradient: Gradient(colors: [.black, .gray.opacity(0.3)]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 16) {
                    // Glassy search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.7))
                        TextField("Search websites...", text: $searchText)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .background(BlurView(style: .systemUltraThinMaterialDark))
                    .cornerRadius(15)
                    .padding(.horizontal)

                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredWebsites) { website in
                                WebsiteRow(website: website)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                                    .shadow(radius: 4)
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .navigationTitle("Websites")
                .foregroundColor(.white)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: { isSorted.toggle() }) {
                            Image(systemName: isSorted ? "arrow.up.arrow.down.circle.fill" : "arrow.up.arrow.down.circle")
                                .foregroundColor(.white)
                        }
                        ThemeToggleButton(isDarkMode: $isDarkMode)
                    }
                }
                .onAppear {
                    viewModel.fetchWebsites()
                }
            }
        }
    }
}
