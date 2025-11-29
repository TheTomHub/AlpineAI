//
//  CalendarService.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation
import EventKit

/// Service for reading calendar events
@MainActor
class CalendarService: ObservableObject {
    @Published var authorizationStatus: EKAuthorizationStatus = .notDetermined
    @Published var isAuthorized: Bool = false

    private let eventStore = EKEventStore()

    init() {
        checkAuthorizationStatus()
    }

    /// Checks current calendar authorization status
    func checkAuthorizationStatus() {
        authorizationStatus = EKEventStore.authorizationStatus(for: .event)
        isAuthorized = authorizationStatus == .fullAccess || authorizationStatus == .authorized
    }

    /// Requests calendar access permission
    func requestAccess() async throws {
        if #available(iOS 17.0, *) {
            let granted = try await eventStore.requestFullAccessToEvents()
            authorizationStatus = granted ? .fullAccess : .denied
        } else {
            let granted = try await eventStore.requestAccess(to: .event)
            authorizationStatus = granted ? .authorized : .denied
        }
        isAuthorized = authorizationStatus == .fullAccess || authorizationStatus == .authorized
    }

    /// Fetches events for today
    func fetchTodayEvents() async -> [EventSummary] {
        guard isAuthorized else {
            return []
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = eventStore.predicateForEvents(
            withStart: startOfDay,
            end: endOfDay,
            calendars: nil
        )

        let events = eventStore.events(matching: predicate)

        return events.map { event in
            EventSummary(
                id: event.eventIdentifier,
                title: event.title,
                startDate: event.startDate,
                endDate: event.endDate,
                isAllDay: event.isAllDay
            )
        }.sorted { $0.startDate < $1.startDate }
    }

    /// Fetches upcoming events (next 3 from now)
    func fetchUpcomingEvents(limit: Int = 3) async -> [EventSummary] {
        guard isAuthorized else {
            return []
        }

        let now = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 7, to: now)!

        let predicate = eventStore.predicateForEvents(
            withStart: now,
            end: endDate,
            calendars: nil
        )

        let events = eventStore.events(matching: predicate)

        return events
            .filter { $0.startDate > now }
            .sorted { $0.startDate < $1.startDate }
            .prefix(limit)
            .map { event in
                EventSummary(
                    id: event.eventIdentifier,
                    title: event.title,
                    startDate: event.startDate,
                    endDate: event.endDate,
                    isAllDay: event.isAllDay
                )
            }
    }
}
