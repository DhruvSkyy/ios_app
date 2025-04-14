//
//  CiscoApp.swift
//  Cisco
//
//  Created by Dhruv Sharma on 10/04/2025.
//

import SwiftUI

@main
struct CiscoApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

        var body: some Scene {
            WindowGroup {
                ContentView()
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            }
        }
}
