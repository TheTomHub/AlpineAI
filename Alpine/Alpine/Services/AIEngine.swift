//
//  AIEngine.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation

/// Context provided to the AI Engine for answering questions
struct AIContext: Codable {
    let todayEvents: [EventSummary]
    let recentNotes: [Note]
    let currentDate: Date
    let userMode: AICoreMode

    var eventCount: Int {
        todayEvents.count
    }

    var noteCount: Int {
        recentNotes.count
    }
}

/// Protocol for AI inference engines
/// This abstraction allows swapping between:
/// - Stub/mock implementations (MVP)
/// - HTTP-based LLM APIs (cloud fallback)
/// - On-device CoreML SLM (final goal)
protocol AIEngine {
    /// Generates an answer to the user's question given contextual data
    /// - Parameters:
    ///   - question: The user's natural language query
    ///   - context: Structured context from local data sources
    /// - Returns: A natural language response
    func answer(question: String, context: AIContext) async throws -> String
}

/// Errors that can occur during AI inference
enum AIEngineError: Error, LocalizedError {
    case modelNotLoaded
    case inferenceTimeout
    case invalidInput
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .modelNotLoaded:
            return "AI model is not loaded"
        case .inferenceTimeout:
            return "Request timed out"
        case .invalidInput:
            return "Invalid input provided"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
