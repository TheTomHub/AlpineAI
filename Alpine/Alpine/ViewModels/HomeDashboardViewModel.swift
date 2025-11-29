//
//  HomeDashboardViewModel.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation

@MainActor
class HomeDashboardViewModel: ObservableObject {
    @Published var upcomingEvents: [EventSummary] = []
    @Published var recentNotes: [Note] = []
    @Published var isLoadingEvents = false

    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    func loadData() async {
        await loadEvents()
        loadNotes()
    }

    func loadEvents() async {
        isLoadingEvents = true
        upcomingEvents = await appState.calendarService.fetchUpcomingEvents(limit: 3)
        isLoadingEvents = false

        // Record calendar sync for progression
        if !upcomingEvents.isEmpty {
            appState.progressService.recordCalendarSync()
        }
    }

    func loadNotes() {
        recentNotes = appState.notesStore.recentNotes(limit: 3)
    }

    func requestCalendarAccess() async {
        do {
            try await appState.calendarService.requestAccess()
            await loadEvents()
        } catch {
            print("Failed to request calendar access: \(error)")
        }
    }
}
