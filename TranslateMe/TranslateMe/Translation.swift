//
//  Translation.swift
//  TranslateMe
//
//  Created by Noah Russell on 11/16/24.
//

import Foundation

struct Translation: Identifiable {
    let id = UUID()
    let input: String
    let translation: String
    let timestamp: Date

    // Initializer with a default value for timestamp if nil
    init(input: String, translation: String, timestamp: Date? = nil) {
        self.input = input
        self.translation = translation
        self.timestamp = timestamp ?? Date() // Default to the current date if nil
    }
}

// Conformance to Comparable for easy sorting
extension Translation: Comparable {
    static func < (lhs: Translation, rhs: Translation) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
}
