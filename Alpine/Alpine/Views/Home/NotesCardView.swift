//
//  NotesCardView.swift
//  Alpine
//
//  Created by Alpine Team
//

import SwiftUI

struct NotesCardView: View {
    let notes: [Note]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            Text("Recent Notes")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)

            // Content
            if notes.isEmpty {
                emptyStateView
            } else {
                notesListView
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(cardBackground)
    }

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "note.text")
                .font(.system(size: 40))
                .foregroundStyle(.white.opacity(0.3))

            Text("No notes yet")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))

            Text("Create your first note to help Alpine learn about you")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }

    private var notesListView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(notes) { note in
                VStack(alignment: .leading, spacing: 6) {
                    Text(note.preview)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    Text(note.formattedDate)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.vertical, 4)

                if note.id != notes.last?.id {
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
                                .purple.opacity(0.3),
                                .pink.opacity(0.1)
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
        NotesCardView(
            notes: [
                Note(text: "Remember to review the Alpine project architecture before the meeting tomorrow"),
                Note(text: "Ideas for improving the AI Core visual feedback")
            ]
        )
        .padding()
    }
}
