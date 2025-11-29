//
//  ConsoleViewModel.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation

struct ConversationMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date
}

@MainActor
class ConsoleViewModel: ObservableObject {
    @Published var messages: [ConversationMessage] = []
    @Published var currentInput = ""
    @Published var isProcessing = false

    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState

        // Add welcome message
        messages.append(ConversationMessage(
            text: "Welcome to Alpine Console. Ask me anything about your day, schedule, or notes.",
            isUser: false,
            timestamp: Date()
        ))
    }

    func sendMessage() async {
        let userMessage = currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userMessage.isEmpty else { return }

        // Add user message to history
        messages.append(ConversationMessage(
            text: userMessage,
            isUser: true,
            timestamp: Date()
        ))

        currentInput = ""
        isProcessing = true

        // Build context
        let context = await buildContext()

        // Get AI response
        do {
            let response = try await appState.aiEngine.answer(
                question: userMessage,
                context: context
            )

            messages.append(ConversationMessage(
                text: response,
                isUser: false,
                timestamp: Date()
            ))

            // Record question for progression
            appState.progressService.recordQuestionAsked()

        } catch {
            messages.append(ConversationMessage(
                text: "Sorry, I encountered an error: \(error.localizedDescription)",
                isUser: false,
                timestamp: Date()
            ))
        }

        isProcessing = false
    }

    private func buildContext() async -> AIContext {
        let todayEvents = await appState.calendarService.fetchTodayEvents()
        let recentNotes = appState.notesStore.recentNotes(limit: 10)

        return AIContext(
            todayEvents: todayEvents,
            recentNotes: recentNotes,
            currentDate: Date(),
            userMode: appState.currentMode
        )
    }

    func clearHistory() {
        messages.removeAll()
        messages.append(ConversationMessage(
            text: "Conversation cleared. How can I help you?",
            isUser: false,
            timestamp: Date()
        ))
    }
}
