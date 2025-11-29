//
//  SettingsView.swift
//  Alpine
//
//  Created by Alpine Team
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel: SettingsViewModel

    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(appState: appState))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView

                    // AI Core Settings
                    settingsSection(title: "AI Core") {
                        // Mode Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mode")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.white.opacity(0.7))

                            Picker("Mode", selection: $viewModel.selectedMode) {
                                ForEach(AICoreMode.allCases, id: \.self) { mode in
                                    Text(mode.rawValue).tag(mode)
                                }
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: viewModel.selectedMode) { _, _ in
                                viewModel.updateMode()
                            }
                        }

                        Divider()
                            .background(.white.opacity(0.1))

                        // Current Level
                        HStack {
                            Text("Current Level")
                                .foregroundStyle(.white)

                            Spacer()

                            Text(appState.currentLevel.phaseLabel)
                                .foregroundStyle(.white.opacity(0.6))
                        }

                        Divider()
                            .background(.white.opacity(0.1))

                        // Usage Stats
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Progress")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.white.opacity(0.7))

                            statsRow(label: "Days Active", value: "\(viewModel.usageStats.uniqueDaysOpened)")
                            statsRow(label: "Notes Created", value: "\(viewModel.usageStats.notesCreated)")
                            statsRow(label: "Questions Asked", value: "\(viewModel.usageStats.questionsAsked)")
                        }

                        Divider()
                            .background(.white.opacity(0.1))

                        // Reset Button
                        Button(role: .destructive) {
                            viewModel.showResetConfirmation = true
                        } label: {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Reset AI Core")
                            }
                            .foregroundStyle(.red)
                        }
                    }

                    // Data Permissions
                    settingsSection(title: "Data Access") {
                        permissionRow(
                            icon: "calendar",
                            label: "Calendar",
                            status: viewModel.calendarStatus
                        )

                        Divider()
                            .background(.white.opacity(0.1))

                        permissionRow(
                            icon: "heart.fill",
                            label: "Health",
                            status: viewModel.healthStatus
                        )
                    }

                    // About
                    settingsSection(title: "About") {
                        infoRow(label: "Version", value: "1.0.0")

                        Divider()
                            .background(.white.opacity(0.1))

                        infoRow(label: "Mode", value: "MVP")
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }
        }
        .confirmationDialog(
            "Reset AI Core?",
            isPresented: $viewModel.showResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset", role: .destructive) {
                viewModel.resetAICore()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will reset your AI Core level and usage statistics. Your notes and settings will be preserved.")
        }
    }

    private var headerView: some View {
        Text("Settings")
            .font(.largeTitle.weight(.bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.5))
                .textCase(.uppercase)

            VStack(alignment: .leading, spacing: 16) {
                content()
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }

    private func statsRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.white.opacity(0.8))
            Spacer()
            Text(value)
                .foregroundStyle(.cyan)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }

    private func permissionRow(icon: String, label: String, status: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.cyan)
                .frame(width: 24)

            Text(label)
                .foregroundStyle(.white)

            Spacer()

            Text(status)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.white)

            Spacer()

            Text(value)
                .foregroundStyle(.white.opacity(0.6))
        }
    }
}

#Preview {
    SettingsView(appState: AppState())
        .environmentObject(AppState())
}
