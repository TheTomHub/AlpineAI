//
//  SettingsViewModel.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var selectedMode: AICoreMode
    @Published var showResetConfirmation = false

    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState
        self.selectedMode = appState.currentMode
    }

    func updateMode() {
        appState.progressService.setMode(selectedMode)
    }

    func resetAICore() {
        appState.progressService.reset()
        showResetConfirmation = false
    }

    var calendarStatus: String {
        appState.calendarService.isAuthorized ? "Authorized" : "Not Authorized"
    }

    var healthStatus: String {
        // TODO: Implement HealthKit integration
        "Coming Soon"
    }

    var usageStats: UsageStats {
        appState.progressService.coreState.usageStats
    }
}
