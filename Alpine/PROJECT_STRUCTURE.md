# Alpine Project Structure

Complete file-by-file breakdown of the Alpine iOS app.

## Directory Tree

```
Alpine/
├── README.md                          # Main documentation
├── XCODE_SETUP.md                     # Xcode configuration guide
├── PROJECT_STRUCTURE.md               # This file
│
└── Alpine/                            # Main source directory
    ├── AlpineApp.swift                # App entry point + main tab view
    ├── Info.plist                     # App configuration & privacy descriptions
    │
    ├── Models/                        # Data structures (all Codable)
    │   ├── AICoreMode.swift           # enum: Student vs Professional
    │   ├── AICoreLevel.swift          # enum: 6 evolution stages (0-5)
    │   ├── AICoreState.swift          # struct: Persistent AI state + usage stats
    │   ├── EventSummary.swift         # struct: Calendar event representation
    │   └── Note.swift                 # struct: User journal entry
    │
    ├── Services/                      # Business logic (@MainActor classes)
    │   ├── AIEngine.swift             # protocol: AI inference abstraction
    │   ├── StubAIEngine.swift         # class: MVP template-based AI responses
    │   ├── CalendarService.swift      # class: EventKit integration
    │   ├── NotesStore.swift           # class: Local notes persistence
    │   └── AICoreProgressService.swift # class: Leveling & progression logic
    │
    ├── ViewModels/                    # MVVM state management
    │   ├── AppState.swift             # class: Root app state + DI container
    │   ├── HomeDashboardViewModel.swift # class: Home screen state
    │   ├── ConsoleViewModel.swift     # class: AI chat state
    │   └── SettingsViewModel.swift    # class: Settings state
    │
    └── Views/                         # SwiftUI interface
        ├── Onboarding/
        │   └── OnboardingView.swift   # Mode selection flow
        │
        ├── Home/
        │   ├── HomeDashboardView.swift # Main dashboard screen
        │   ├── AICoreWidgetView.swift  # AI Core card widget
        │   ├── TodayCardView.swift     # Calendar events card
        │   └── NotesCardView.swift     # Recent notes card
        │
        ├── Console/
        │   └── ConsoleView.swift       # AI chat interface + MessageBubble
        │
        ├── Settings/
        │   └── SettingsView.swift      # Settings screen with sections
        │
        └── Components/
            └── AICoreView.swift        # Animated AI Core visual (dual-mode)
```

---

## File Descriptions

### Root Files

#### `AlpineApp.swift`
- **@main** entry point
- Creates root `AppState`
- Conditional rendering: `OnboardingView` vs `MainTabView`
- Includes: `MainTabView`, `NotesListView`, `NoteDetailView`, `NewNoteSheet`

#### `Info.plist`
- Bundle configuration
- Privacy usage descriptions for Calendar & HealthKit
- Launch screen configuration

---

### Models/

**All models conform to `Codable` for easy persistence**

#### `AICoreMode.swift`
- `enum AICoreMode: String, Codable`
- Cases: `.student`, `.professional`
- Properties: `description`, `tagline`

#### `AICoreLevel.swift`
- `enum AICoreLevel: Int, Codable`
- Cases: `.dormant` (0) → `.predictive` (5)
- Properties: `name`, `description`, `phaseLabel`
- Visual properties: `glowIntensity`, `scale`, `rotationSpeed`

#### `AICoreState.swift`
- `struct AICoreState: Codable`
- Fields: `mode`, `level`, `lastUpdated`, `usageStats`
- Nested: `struct UsageStats` (tracks progression triggers)

#### `EventSummary.swift`
- `struct EventSummary: Identifiable, Codable`
- Fields: `id`, `title`, `startDate`, `endDate`, `isAllDay`
- Computed: `formattedTime`, `formattedDateRange`

#### `Note.swift`
- `struct Note: Identifiable, Codable`
- Fields: `id`, `text`, `createdAt`, `modifiedAt`
- Computed: `preview`, `formattedDate`

---

### Services/

**All services are @MainActor ObservableObject classes**

#### `AIEngine.swift`
- `protocol AIEngine` – inference abstraction
- `struct AIContext` – context payload (events, notes, mode)
- `enum AIEngineError` – error types

#### `StubAIEngine.swift`
- `class StubAIEngine: AIEngine`
- Template-based response generation
- Analyzes question intent (schedule, notes, availability)
- TODO comments for CoreML/HTTP implementations

#### `CalendarService.swift`
- `class CalendarService: ObservableObject`
- EventKit wrapper
- Methods: `requestAccess()`, `fetchTodayEvents()`, `fetchUpcomingEvents()`
- Published: `authorizationStatus`, `isAuthorized`

#### `NotesStore.swift`
- `class NotesStore: ObservableObject`
- UserDefaults-backed note storage
- Methods: `createNote()`, `updateNote()`, `deleteNote()`
- Published: `notes` array

#### `AICoreProgressService.swift`
- `class AICoreProgressService: ObservableObject`
- Manages AI Core state and leveling
- Methods: `setMode()`, `recordAppOpen()`, `recordNoteCreated()`, etc.
- Auto-leveling logic based on usage thresholds
- Published: `coreState`

---

### ViewModels/

**All conform to @MainActor ObservableObject**

#### `AppState.swift`
- Root dependency container
- Owns all services (singleton pattern)
- Manages onboarding state
- Computed: `currentMode`, `currentLevel`, `greeting`

#### `HomeDashboardViewModel.swift`
- State for home dashboard
- Methods: `loadData()`, `loadEvents()`, `requestCalendarAccess()`
- Published: `upcomingEvents`, `recentNotes`, `isLoadingEvents`

#### `ConsoleViewModel.swift`
- Chat conversation state
- Methods: `sendMessage()`, `clearHistory()`, `buildContext()`
- Published: `messages`, `currentInput`, `isProcessing`
- Nested: `struct ConversationMessage`

#### `SettingsViewModel.swift`
- Settings screen state
- Methods: `updateMode()`, `resetAICore()`
- Computed: `calendarStatus`, `healthStatus`, `usageStats`
- Published: `selectedMode`, `showResetConfirmation`

---

### Views/

#### Onboarding/OnboardingView.swift
- Mode selection screen
- Components: `ModeCard` (selectable AI mode preview)
- "Begin" button → completes onboarding

#### Home/HomeDashboardView.swift
- Main dashboard
- Sections: Header, AI Core Widget, Today Card, Notes Card
- Pull-to-refresh support

#### Home/AICoreWidgetView.swift
- Displays `AICoreView` with level info
- Glass-morphic card design

#### Home/TodayCardView.swift
- Shows upcoming events or empty state
- "Enable Calendar Access" button
- LCARS-inspired cyan accent

#### Home/NotesCardView.swift
- Shows recent notes or empty state
- Purple/pink accent gradient

#### Console/ConsoleView.swift
- AI chat interface
- Components: `MessageBubble` (user vs AI styling)
- Input field with send button
- Auto-scrolls to latest message

#### Settings/SettingsView.swift
- Grouped settings sections
- Mode picker, level display, usage stats
- Reset confirmation dialog
- Data permissions status

#### Components/AICoreView.swift
- **Dual-mode animated visual**
- Student mode: Creature-like blob with eyes
- Professional mode: Geometric shapes (hexagon, triangle)
- Level-based colors and animations
- Custom shapes: `RegularPolygon`

---

## Data Flow

### MVVM Pattern

```
User Interaction
    ↓
View (SwiftUI)
    ↓
ViewModel (@Published state)
    ↓
Service (business logic)
    ↓
Model (data structure)
    ↓
Persistence (UserDefaults)
```

### Example: Creating a Note

1. User taps "Save" in `NewNoteSheet`
2. Calls `appState.notesStore.createNote(text:)`
3. `NotesStore` creates `Note` model
4. Adds to `@Published notes` array
5. Saves to UserDefaults
6. Calls `appState.progressService.recordNoteCreated()`
7. `AICoreProgressService` checks for level up
8. UI auto-updates via Combine publishers

---

## Key Technologies

- **SwiftUI** – Declarative UI framework
- **Combine** – Reactive `@Published` properties
- **EventKit** – Calendar access
- **async/await** – Modern concurrency
- **@MainActor** – Thread safety for UI

---

## Extension Points

### Add New Data Source

1. Create service in `Services/` (e.g., `HealthService.swift`)
2. Add to `AppState` as property
3. Update `AIContext` to include new data
4. Modify `StubAIEngine` to use new context

### Add New Screen

1. Create view in `Views/[Category]/`
2. Create corresponding ViewModel
3. Add to `MainTabView` or navigation

### Add Persistence Layer

1. Replace UserDefaults in services
2. Create CoreData model
3. Update save/load methods

---

## Testing Strategy

### Unit Tests (TODO)

- Test ViewModels in isolation
- Mock services with protocols
- Test progression logic

### UI Tests (TODO)

- Test onboarding flow
- Test note creation
- Test AI Console interaction

### Snapshot Tests (TODO)

- Test AI Core visuals at each level
- Test both student and professional modes

---

## Performance Considerations

### Current

- Lightweight models (all structs)
- Minimal state duplication
- Lazy loading where possible

### Future Optimizations

- Pagination for large note lists
- Background fetch for calendar
- CoreML model warming
- Embedding cache

---

## Build Targets

**Current:** iOS 17.0+
**Future:** iOS 17.0+ (maintain), watchOS, macOS (Catalyst)

---

For setup instructions, see `XCODE_SETUP.md`
For architecture details, see `README.md`
