import Foundation
import SwiftUI

// MARK: - Models

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let role: String
    let content: String
}

struct ChatRequest: Codable {
    let message: String
    let temperature: Double
}

struct ChatResponse: Codable {
    let response: String
    let model: String
    let tokensUsed: Int?

    enum CodingKeys: String, CodingKey {
        case response, model
        case tokensUsed = "tokens_used"
    }
}

struct AnalysisRequest: Codable {
    let text: String
    let analysisType: String

    enum CodingKeys: String, CodingKey {
        case text
        case analysisType = "analysis_type"
    }
}

struct AnalysisResponse: Codable {
    let result: AnalysisResult
    let analysisType: String

    enum CodingKeys: String, CodingKey {
        case result
        case analysisType = "analysis_type"
    }
}

struct AnalysisResult: Codable {
    let textLength: Int
    let wordCount: Int
    let sentiment: String?
    let confidence: Double?

    enum CodingKeys: String, CodingKey {
        case textLength = "text_length"
        case wordCount = "word_count"
        case sentiment
        case confidence
    }
}

struct HealthResponse: Codable {
    let status: String
    let version: String
    let environment: String
}

struct AlertMessage: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

// MARK: - ViewModel

@MainActor
class AlpineViewModel: ObservableObject {
    @Published var chatHistory: [ChatMessage] = []
    @Published var analysisResult: AnalysisResult?
    @Published var isLoading = false
    @Published var alertMessage: AlertMessage?

    // IMPORTANT: Change this if testing on a physical iPhone
    // Use your Mac's IP address: http://192.168.1.XXX:8000
    private let baseURL = "http://localhost:8000"

    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: configuration)
    }

    // MARK: - API Methods

    func checkHealth() async {
        do {
            let url = URL(string: "\(baseURL)/health")!
            let (data, _) = try await session.data(from: url)
            let health = try JSONDecoder().decode(HealthResponse.self, from: data)

            alertMessage = AlertMessage(
                title: "✅ API Status",
                message: "Status: \(health.status)\nVersion: \(health.version)"
            )
        } catch {
            alertMessage = AlertMessage(
                title: "❌ Connection Error",
                message: "Cannot connect to API. Make sure the backend is running!"
            )
        }
    }

    func sendMessage(_ text: String) async {
        let userMessage = ChatMessage(role: "user", content: text)
        chatHistory.append(userMessage)
        isLoading = true

        do {
            let url = URL(string: "\(baseURL)/api/v1/chat")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let chatRequest = ChatRequest(message: text, temperature: 0.7)
            request.httpBody = try JSONEncoder().encode(chatRequest)

            let (data, _) = try await session.data(for: request)
            let response = try JSONDecoder().decode(ChatResponse.self, from: data)

            let assistantMessage = ChatMessage(role: "assistant", content: response.response)
            chatHistory.append(assistantMessage)
        } catch {
            let errorMessage = ChatMessage(
                role: "error",
                content: "Failed to get response. Check your connection."
            )
            chatHistory.append(errorMessage)
        }

        isLoading = false
    }

    func analyzeText(_ text: String) async {
        guard !text.isEmpty else { return }
        isLoading = true

        do {
            let url = URL(string: "\(baseURL)/api/v1/analyze")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let analysisRequest = AnalysisRequest(text: text, analysisType: "sentiment")
            request.httpBody = try JSONEncoder().encode(analysisRequest)

            let (data, _) = try await session.data(for: request)
            let response = try JSONDecoder().decode(AnalysisResponse.self, from: data)

            analysisResult = response.result
        } catch {
            alertMessage = AlertMessage(
                title: "Error",
                message: "Failed to analyze text. Check your connection."
            )
        }

        isLoading = false
    }

    func clearChat() {
        chatHistory.removeAll()
    }
}
