//
//  ThemeToggleButton.swift
//  Cisco
//
//  Created by Dhruv Sharma on 14/04/2025.
//

import SwiftUI

struct ThemeToggleButton: View {
    @Binding var isDarkMode: Bool

    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                isDarkMode.toggle()
            }
        }) {
            ZStack {
                Capsule()
                    .fill(isDarkMode ? Color.gray.opacity(0.3) : Color.yellow.opacity(0.3))
                    .frame(width: 40, height: 20)

                HStack {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 10))
                        .opacity(isDarkMode ? 0 : 1)
                    Spacer()
                    Image(systemName: "moon.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .opacity(isDarkMode ? 1 : 0)
                }
                .padding(.horizontal, 5)

                Circle()
                    .fill(isDarkMode ? Color.white : Color.yellow)
                    .frame(width: 16, height: 16)
                    .offset(x: isDarkMode ? 10 : -10)
                    .shadow(radius: 1)
            }
        }
        .frame(width: 40, height: 20)
    }
}
