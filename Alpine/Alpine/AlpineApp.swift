//
//  AlpineApp.swift
//  Alpine
//
//  Created by Alpine Team
//

import SwiftUI

@main
struct AlpineApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            Group {
                if appState.hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(appState)
            .preferredColorScheme(.dark) // Force dark mode for LCARS aesthetic
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeDashboardView(appState: appState)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            ConsoleView(appState: appState)
                .tabItem {
                    Label("Console", systemImage: "terminal.fill")
                }
                .tag(1)

            NotesListView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                .tag(2)

            SettingsView(appState: appState)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(.cyan)
    }
}

// MARK: - Notes List View

struct NotesListView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingNewNote = false
    @State private var newNoteText = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {
                    if appState.notesStore.notes.isEmpty {
                        emptyStateView
                    } else {
                        notesList
                    }
                }
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewNote) {
                NewNoteSheet(
                    noteText: $newNoteText,
                    onSave: {
                        appState.notesStore.createNote(text: newNoteText)
                        appState.progressService.recordNoteCreated()
                        newNoteText = ""
                        showingNewNote = false
                    },
                    onCancel: {
                        newNoteText = ""
                        showingNewNote = false
                    }
                )
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.3))

            Text("No Notes Yet")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)

            Text("Create your first note to help Alpine understand you better")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button("Create Note") {
                showingNewNote = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.cyan)
        }
    }

    private var notesList: some View {
        List {
            ForEach(appState.notesStore.notes) { note in
                NavigationLink {
                    NoteDetailView(note: note)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(note.preview)
                            .foregroundStyle(.white)
                            .lineLimit(2)

                        Text(note.formattedDate)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(.vertical, 4)
                }
            }
            .onDelete { indexSet in
                appState.notesStore.deleteNotes(at: indexSet)
            }
            .listRowBackground(Color.white.opacity(0.05))
        }
        .scrollContentBackground(.hidden)
    }
}

// MARK: - Note Detail View

struct NoteDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    let note: Note

    @State private var editedText: String
    @State private var isEditing = false

    init(note: Note) {
        self.note = note
        _editedText = State(initialValue: note.text)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(note.formattedDate)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))

                    if isEditing {
                        TextEditor(text: $editedText)
                            .foregroundStyle(.white)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 200)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                            )
                    } else {
                        Text(editedText)
                            .foregroundStyle(.white)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        appState.notesStore.updateNote(note, text: editedText)
                    }
                    isEditing.toggle()
                }
            }

            ToolbarItem(placement: .destructive) {
                Button("Delete", role: .destructive) {
                    appState.notesStore.deleteNote(note)
                    dismiss()
                }
            }
        }
    }
}

// MARK: - New Note Sheet

struct NewNoteSheet: View {
    @Binding var noteText: String
    let onSave: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {
                    TextEditor(text: $noteText)
                        .foregroundStyle(.white)
                        .scrollContentBackground(.hidden)
                        .padding()
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancel()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                    }
                    .disabled(noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
