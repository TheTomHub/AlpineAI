//
//  AppState.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation
import SwiftUI

/// Root application state and dependency container
@MainActor
class AppState: ObservableObject {
    // MARK: - Services
    let calendarService = CalendarService()
    let notesStore = NotesStore()
    let progressService = AICoreProgressService()
    let aiEngine: AIEngine = StubAIEngine() // TODO: Replace with CoreMLAIEngine

    // MARK: - Onboarding
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "alpine.onboardingCompleted")
        }
    }

    init() {
        // Load onboarding state
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "alpine.onboardingCompleted")
    }

    func completeOnboarding(mode: AICoreMode) {
        progressService.setMode(mode)
        hasCompletedOnboarding = true
    }

    // MARK: - Computed Properties

    var currentMode: AICoreMode {
        progressService.coreState.mode
    }

    var currentLevel: AICoreLevel {
        progressService.coreState.level
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }
}
