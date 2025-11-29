//
//  AICoreProgressService.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation

/// Service for managing AI Core progression and leveling
@MainActor
class AICoreProgressService: ObservableObject {
    @Published private(set) var coreState: AICoreState

    private let storageKey = "alpine.aiCoreState"

    init() {
        // Load saved state or create new
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let state = try? JSONDecoder().decode(AICoreState.self, from: data) {
            self.coreState = state
        } else {
            self.coreState = AICoreState()
        }

        // Record app open
        recordAppOpen()
    }

    // MARK: - State Management

    /// Changes the AI Core mode
    func setMode(_ mode: AICoreMode) {
        coreState.mode = mode
        coreState.lastUpdated = Date()
        saveState()
    }

    /// Manually sets the level (for debugging/testing)
    func setLevel(_ level: AICoreLevel) {
        coreState.level = level
        coreState.lastUpdated = Date()
        saveState()
    }

    /// Resets the AI Core to initial state
    func reset() {
        coreState = AICoreState(mode: coreState.mode)
        saveState()
    }

    // MARK: - Usage Tracking & Auto-Leveling

    func recordAppOpen() {
        coreState.usageStats.recordAppOpen()
        saveState()
        checkForLevelUp()
    }

    func recordCalendarSync() {
        coreState.usageStats.recordCalendarSync()
        saveState()
        checkForLevelUp()
    }

    func recordNoteCreated() {
        coreState.usageStats.recordNoteCreated()
        saveState()
        checkForLevelUp()
    }

    func recordQuestionAsked() {
        coreState.usageStats.recordQuestionAsked()
        saveState()
        checkForLevelUp()
    }

    // MARK: - Level Progression Logic

    /// Checks if the AI Core should level up based on usage
    private func checkForLevelUp() {
        let stats = coreState.usageStats
        let currentLevel = coreState.level

        let newLevel: AICoreLevel? = {
            switch currentLevel {
            case .dormant:
                // Level 1: After calendar sync
                return stats.calendarSynced ? .spark : nil

            case .spark:
                // Level 2: After opening app on 3 separate days
                return stats.uniqueDaysOpened >= 3 ? .awareness : nil

            case .awareness:
                // Level 3: After creating 5 notes
                return stats.notesCreated >= 5 ? .patternRecognition : nil

            case .patternRecognition:
                // Level 4: After first AI Console question
                return stats.questionsAsked >= 1 ? .contextual : nil

            case .contextual:
                // Level 5: After 10 questions or 10 notes (whichever comes first)
                return (stats.questionsAsked >= 10 || stats.notesCreated >= 10) ? .predictive : nil

            case .predictive:
                // Max level reached
                return nil
            }
        }()

        if let newLevel = newLevel {
            levelUp(to: newLevel)
        }
    }

    private func levelUp(to newLevel: AICoreLevel) {
        guard newLevel.rawValue > coreState.level.rawValue else {
            return
        }

        coreState.level = newLevel
        coreState.lastUpdated = Date()
        saveState()

        // TODO: Add notification or visual feedback for level up
        print("🎉 AI Core leveled up to: \(newLevel.name)")
    }

    // MARK: - Persistence

    private func saveState() {
        do {
            let data = try JSONEncoder().encode(coreState)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Failed to save AI Core state: \(error)")
        }
    }

    // TODO: Add analytics/telemetry for understanding user progression patterns
    // TODO: Consider adding achievements/milestones system
    // TODO: Add local notifications for level-up events
}
