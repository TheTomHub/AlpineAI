//
//  HomeDashboardView.swift
//  Alpine
//
//  Created by Alpine Team
//

import SwiftUI

struct HomeDashboardView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel: HomeDashboardViewModel

    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: HomeDashboardViewModel(appState: appState))
    }

    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView

                    // AI Core Widget
                    AICoreWidgetView(
                        mode: appState.currentMode,
                        level: appState.currentLevel
                    )

                    // Today Card
                    TodayCardView(
                        events: viewModel.upcomingEvents,
                        isLoading: viewModel.isLoadingEvents,
                        onRequestAccess: {
                            Task {
                                await viewModel.requestCalendarAccess()
                            }
                        }
                    )

                    // Notes Card
                    NotesCardView(notes: viewModel.recentNotes)

                    Spacer(minLength: 20)
                }
                .padding()
            }
        }
        .task {
            await viewModel.loadData()
        }
        .refreshable {
            await viewModel.loadData()
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(appState.greeting)
                .font(.title.weight(.semibold))
                .foregroundStyle(.white)

            Text(formattedDate)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
}

// MARK: - Preview

#Preview {
    HomeDashboardView(appState: AppState())
        .environmentObject(AppState())
}
