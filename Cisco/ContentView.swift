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
            VStack(spacing: 12) {
                // Search Bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search websites...", text: $searchText)
                        .foregroundColor(.primary)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(12)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)

                // Card-style website list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredWebsites) { website in
                            WebsiteRow(website: website)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }

            }
            .navigationTitle("Websites")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { isSorted.toggle() }) {
                        Label(isSorted ? "Unsort" : "Sort A–Z", systemImage: isSorted ? "arrow.up.arrow.down.circle.fill" : "arrow.up.arrow.down.circle")
                            .labelStyle(IconOnlyLabelStyle())
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }

                    ThemeToggleButton(isDarkMode: $isDarkMode)
                        .imageScale(.large)
                }
            }
            .onAppear {
                viewModel.fetchWebsites()
            }
        }
    }
}
