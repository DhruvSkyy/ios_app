//
//  Website.swift
//  Cisco
//
//  Created by Dhruv Sharma on 10/04/2025.
//

// Website.swift

import Foundation

struct Website: Identifiable, Codable {
    let id = UUID()
    let name: String
    let url: String
    let icon: String?
    let description: String
}

