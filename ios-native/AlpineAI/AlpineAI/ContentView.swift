import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AlpineViewModel()
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Text("🏔️ Alpine AI")
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: {
                        Task {
                            await viewModel.checkHealth()
                        }
                    }) {
                        Text("Health Check")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)

                // Tab Selector
                Picker("", selection: $selectedTab) {
                    Text("💬 Chat").tag(0)
                    Text("🔍 Analyze").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Content
                if selectedTab == 0 {
                    ChatView(viewModel: viewModel)
                } else {
                    AnalyzeView(viewModel: viewModel)
                }
            }
            .navigationBarHidden(true)
        }
        .alert(item: $viewModel.alertMessage) { alert in
            Alert(title: Text(alert.title), message: Text(alert.message))
        }
    }
}

struct ChatView: View {
    @ObservedObject var viewModel: AlpineViewModel
    @State private var inputText = ""
    @State private var scrollProxy: ScrollViewProxy? = nil

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        if viewModel.chatHistory.isEmpty {
                            VStack(spacing: 8) {
                                Text("Welcome to Alpine AI! 👋")
                                    .font(.title3)
                                Text("Start a conversation below.")
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 100)
                        }

                        ForEach(viewModel.chatHistory) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }

                        if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                    .padding(.trailing, 8)
                                Text("Thinking...")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                    }
                    .padding()
                }
                .onAppear {
                    scrollProxy = proxy
                }
                .onChange(of: viewModel.chatHistory.count) { _ in
                    if let lastMessage = viewModel.chatHistory.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Input Area
            HStack(spacing: 8) {
                if !viewModel.chatHistory.isEmpty {
                    Button(action: {
                        viewModel.clearChat()
                    }) {
                        Text("Clear")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                TextField("Type your message...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        sendMessage()
                    }

                Button(action: sendMessage) {
                    Text("Send")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(inputText.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(20)
                }
                .disabled(inputText.isEmpty || viewModel.isLoading)
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }

    private func sendMessage() {
        let message = inputText
        guard !message.isEmpty else { return }
        inputText = ""

        Task {
            await viewModel.sendMessage(message)
        }
    }
}

struct AnalyzeView: View {
    @ObservedObject var viewModel: AlpineViewModel
    @State private var textToAnalyze = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Text Analysis")
                    .font(.title2)
                    .fontWeight(.bold)

                TextEditor(text: $textToAnalyze)
                    .frame(height: 150)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                Button(action: {
                    Task {
                        await viewModel.analyzeText(textToAnalyze)
                    }
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Analyze Sentiment")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(textToAnalyze.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(textToAnalyze.isEmpty || viewModel.isLoading)

                if let result = viewModel.analysisResult {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Analysis Results:")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 8) {
                            ResultRow(icon: "📊", label: "Word Count", value: "\(result.wordCount)")
                            ResultRow(icon: "📝", label: "Character Count", value: "\(result.textLength)")

                            if let sentiment = result.sentiment {
                                ResultRow(icon: "😊", label: "Sentiment", value: sentiment)
                            }

                            if let confidence = result.confidence {
                                ResultRow(icon: "🎯", label: "Confidence", value: "\(Int(confidence * 100))%")
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                    .padding(.top)
                }
            }
            .padding()
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.role == "user" {
                Spacer()
            }

            VStack(alignment: message.role == "user" ? .trailing : .leading, spacing: 4) {
                Text(message.role == "user" ? "👤 You" : "🤖 Alpine")
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(message.content)
                    .padding(12)
                    .background(message.role == "user" ? Color.blue : Color(.systemGray6))
                    .foregroundColor(message.role == "user" ? .white : .primary)
                    .cornerRadius(16)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: message.role == "user" ? .trailing : .leading)

            if message.role == "assistant" {
                Spacer()
            }
        }
    }
}

struct ResultRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text("\(icon) \(label):")
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
