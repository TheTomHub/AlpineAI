//
//  EventSummary.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation

/// Lightweight representation of a calendar event
struct EventSummary: Identifiable, Codable {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool

    var formattedTime: String {
        if isAllDay {
            return "All day"
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: startDate)
    }

    var formattedDateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        if Calendar.current.isDate(startDate, inSameDayAs: endDate) {
            return "\(formatter.string(from: startDate))"
        } else {
            return "\(formatter.string(from: startDate)) – \(formatter.string(from: endDate))"
        }
    }
}
