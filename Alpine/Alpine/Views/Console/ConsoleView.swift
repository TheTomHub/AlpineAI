//
//  ConsoleView.swift
//  Alpine
//
//  Created by Alpine Team
//

import SwiftUI

struct ConsoleView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel: ConsoleViewModel
    @FocusState private var isInputFocused: Bool

    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: ConsoleViewModel(appState: appState))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerView
                    .padding()

                Divider()
                    .background(.white.opacity(0.1))

                // Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }

                            if viewModel.isProcessing {
                                HStack {
                                    ProgressView()
                                        .tint(.white)
                                    Text("Thinking...")
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                                .padding()
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.messages.count) { _, _ in
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // Input Area
                inputView
                    .padding()
            }
        }
    }

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Alpine Console")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)

                Text("Ask anything about your day")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()

            Menu {
                Button("Clear History", role: .destructive) {
                    viewModel.clearHistory()
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
                    .foregroundStyle(.white)
            }
        }
    }

    private var inputView: some View {
        HStack(spacing: 12) {
            TextField("Ask Alpine...", text: $viewModel.currentInput, axis: .vertical)
                .textFieldStyle(.plain)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                )
                .foregroundStyle(.white)
                .focused($isInputFocused)
                .lineLimit(1...5)
                .onSubmit {
                    Task {
                        await viewModel.sendMessage()
                    }
                }

            Button {
                Task {
                    await viewModel.sendMessage()
                }
            } label: {
                Image(systemName: viewModel.currentInput.isEmpty ? "paperplane" : "paperplane.fill")
                    .font(.title3)
                    .foregroundStyle(viewModel.currentInput.isEmpty ? .white.opacity(0.3) : .cyan)
            }
            .disabled(viewModel.currentInput.isEmpty || viewModel.isProcessing)
        }
    }
}

struct MessageBubble: View {
    let message: ConversationMessage

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if !message.isUser {
                iconView
            }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.body)
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(message.isUser ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
                    )

                Text(timeString(from: message.timestamp))
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.4))
            }
            .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)

            if message.isUser {
                Spacer()
            }
        }
    }

    private var iconView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.cyan, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32, height: 32)

            Image(systemName: "sparkles")
                .font(.system(size: 14))
                .foregroundStyle(.white)
        }
    }

    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ConsoleView(appState: AppState())
        .environmentObject(AppState())
}
