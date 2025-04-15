//
//  ContentView.swift
//  Cisco
//
//  Created by Dhruv Sharma on 10/04/2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var viewModel = WebsiteViewModel()
    @State private var isSorted = false
    @State private var searchText = ""

    // Filters and optionally sorts the list based on search text
    private var filteredWebsites: [Website] {
        let source = isSorted
            ? viewModel.websites.sorted { $0.name < $1.name }
            : viewModel.websites

        guard !searchText.isEmpty else {
            return source
        }

        return source.filter { website in
            website.name.localizedCaseInsensitiveContains(searchText)
            || website.url.localizedCaseInsensitiveContains(searchText)
            || website.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                // Search bar
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

                // Scrollable list of filtered websites
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
                // Top-right toolbar with sort and theme toggle buttons
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { isSorted.toggle() }) {
                        Label(
                            isSorted ? "Unsort" : "Sort A–Z",
                            systemImage: isSorted
                                ? "arrow.up.arrow.down.circle.fill"
                                : "arrow.up.arrow.down.circle"
                        )
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
