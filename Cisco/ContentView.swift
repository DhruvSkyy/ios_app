import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var viewModel = WebsiteViewModel()
    @State private var isSorted = false
    @State private var searchText = ""

    var filteredWebsites: [Website] {
        let source = isSorted ? viewModel.websites.sorted(by: { $0.name < $1.name }) : viewModel.websites

        if searchText.isEmpty {
            return source
        }

        return source.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.url.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Enhanced Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search websites...", text: $searchText)
                        .foregroundColor(.primary)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(10)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)

                // Website list
                List(filteredWebsites) { website in
                    WebsiteRow(website: website)
                }
            }
            .navigationTitle("Websites")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSorted.toggle()
                    }) {
                        Text(isSorted ? "Unsort" : "Sort A-Z")
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
