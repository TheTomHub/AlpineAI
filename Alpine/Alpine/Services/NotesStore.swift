//
//  NotesStore.swift
//  Alpine
//
//  Created by Alpine Team
//

import Foundation

/// Service for managing user notes/journal entries
@MainActor
class NotesStore: ObservableObject {
    @Published private(set) var notes: [Note] = []

    private let storageKey = "alpine.notes"

    init() {
        loadNotes()
    }

    /// Creates a new note
    func createNote(text: String) {
        let note = Note(text: text)
        notes.insert(note, at: 0)
        saveNotes()
    }

    /// Updates an existing note
    func updateNote(_ note: Note, text: String) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else {
            return
        }
        var updatedNote = note
        updatedNote.text = text
        updatedNote.modifiedAt = Date()
        notes[index] = updatedNote
        saveNotes()
    }

    /// Deletes a note
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }

    /// Deletes notes at specific offsets (for SwiftUI list)
    func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes()
    }

    /// Returns recent notes (default 5)
    func recentNotes(limit: Int = 5) -> [Note] {
        Array(notes.prefix(limit))
    }

    // MARK: - Persistence

    private func saveNotes() {
        do {
            let data = try JSONEncoder().encode(notes)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Failed to save notes: \(error)")
        }
    }

    private func loadNotes() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }

        do {
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            print("Failed to load notes: \(error)")
        }
    }

    // TODO: For production, consider using:
    // - CoreData for structured storage and querying
    // - SQLite with GRDB for SQL access
    // - File-based storage with encryption for privacy
    // - Vector embeddings for semantic search
}
