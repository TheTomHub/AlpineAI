//
//  Note.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation

/// Represents a user-created journal entry or note
struct Note: Identifiable, Codable {
    let id: UUID
    var text: String
    let createdAt: Date
    var modifiedAt: Date

    init(id: UUID = UUID(), text: String, createdAt: Date = Date()) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.modifiedAt = createdAt
    }

    var preview: String {
        let maxLength = 100
        if text.count > maxLength {
            return String(text.prefix(maxLength)) + "…"
        }
        return text
    }

    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}
