//
//  AICoreState.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation

/// Represents the persistent state of the AI Core
struct AICoreState: Codable {
    var mode: AICoreMode
    var level: AICoreLevel
    var lastUpdated: Date
    var usageStats: UsageStats

    init(mode: AICoreMode = .student, level: AICoreLevel = .dormant) {
        self.mode = mode
        self.level = level
        self.lastUpdated = Date()
        self.usageStats = UsageStats()
    }
}

/// Tracks usage metrics for AI Core progression
struct UsageStats: Codable {
    var appOpenDays: Set<String> = [] // ISO date strings
    var notesCreated: Int = 0
    var questionsAsked: Int = 0
    var calendarSynced: Bool = false

    var uniqueDaysOpened: Int {
        appOpenDays.count
    }

    mutating func recordAppOpen() {
        let today = ISO8601DateFormatter().string(from: Date()).prefix(10)
        appOpenDays.insert(String(today))
    }

    mutating func recordNoteCreated() {
        notesCreated += 1
    }

    mutating func recordQuestionAsked() {
        questionsAsked += 1
    }

    mutating func recordCalendarSync() {
        calendarSynced = true
    }
}
