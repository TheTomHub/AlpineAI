//
//  TodayCardView.swift
//  Alpine
//
//  Created by Alpine Team
//

import SwiftUI

struct TodayCardView: View {
    let events: [EventSummary]
    let isLoading: Bool
    let onRequestAccess: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("Today")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)

                Spacer()

                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }

            // Content
            if events.isEmpty {
                emptyStateView
            } else {
                eventsListView
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(cardBackground)
    }

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar")
                .font(.system(size: 40))
                .foregroundStyle(.white.opacity(0.3))

            Text("No events today")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))

            Button("Enable Calendar Access") {
                onRequestAccess()
            }
            .font(.footnote)
            .foregroundStyle(.blue)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }

    private var eventsListView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(events) { event in
                HStack(alignment: .top, spacing: 12) {
                    // Time indicator
                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.formattedTime)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.cyan)
                    }
                    .frame(width: 70, alignment: .leading)

                    // Event details
                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.title)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 4)

                if event.id != events.last?.id {
                    Divider()
                        .background(.white.opacity(0.1))
                }
            }
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .cyan.opacity(0.3),
                                .blue.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            TodayCardView(
                events: [
                    EventSummary(id: "1", title: "Team Meeting", startDate: Date(), endDate: Date().addingTimeInterval(3600), isAllDay: false),
                    EventSummary(id: "2", title: "Lunch", startDate: Date().addingTimeInterval(7200), endDate: Date().addingTimeInterval(9000), isAllDay: false)
                ],
                isLoading: false,
                onRequestAccess: {}
            )
            .padding()
        }
    }
}
