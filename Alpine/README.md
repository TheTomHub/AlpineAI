# Alpine

**A sovereign, on-device AI console for iPhone**

Alpine transforms your personal data (calendar, notes, and optionally health data) into intelligent dashboards and insights through a beautiful, LCARS-inspired interface.

---

## Overview

Alpine is designed as a **privacy-first, local-AI assistant** with two distinct personality modes:

- **Student Mode** – A playful, evolving AI creature that grows with your usage
- **Professional Mode** – A sleek, geometric intelligence core for productivity

### Core Features (MVP)

- ✅ **Dual-Mode AI Core** with 6 evolutionary levels (Dormant → Predictive)
- ✅ **Calendar Integration** – Read-only access to your upcoming events
- ✅ **Local Notes/Journal** – Create and manage personal notes
- ✅ **AI Console** – Ask questions about your day, schedule, and notes
- ✅ **Progressive Growth** – AI Core levels up based on usage patterns
- ✅ **Beautiful UI** – LCARS-inspired design with Apple aesthetics
- ✅ **Dark Mode** – Optimized for low-light environments

---

## Architecture

Alpine is built with a **clean, modular architecture** to enable easy swapping of AI backends:

```
Alpine/
├── Models/              # Data structures
│   ├── AICoreMode.swift
│   ├── AICoreLevel.swift
│   ├── AICoreState.swift
│   ├── EventSummary.swift
│   └── Note.swift
│
├── Services/            # Business logic
│   ├── AIEngine.swift           # Protocol for AI inference
│   ├── StubAIEngine.swift       # MVP stub implementation
│   ├── CalendarService.swift    # EventKit integration
│   ├── NotesStore.swift         # Local notes persistence
│   └── AICoreProgressService.swift
│
├── ViewModels/          # MVVM state management
│   ├── AppState.swift
│   ├── HomeDashboardViewModel.swift
│   ├── ConsoleViewModel.swift
│   └── SettingsViewModel.swift
│
└── Views/               # SwiftUI interface
    ├── Onboarding/
    ├── Home/
    ├── Console/
    ├── Settings/
    └── Components/
```

### Key Design Patterns

- **Protocol-Oriented AI** – `AIEngine` protocol allows swapping between stub, HTTP, or CoreML implementations
- **MVVM** – Clean separation between UI and business logic
- **Async/await** – Modern Swift concurrency throughout
- **@MainActor** – Proper thread safety for UI updates

---

## Getting Started

### Requirements

- **Xcode 15.0+**
- **iOS 17.0+**
- **Swift 5.9+**

### Setup

1. **Clone or download** this repository

2. **Open the project in Xcode:**
   ```bash
   cd Alpine
   open Alpine.xcodeproj
   ```

3. **Select your target device** (iPhone simulator or physical device)

4. **Build and run** (⌘R)

### First Launch

1. **Onboarding** – Select your mode (Student or Professional)
2. **Grant Calendar Access** – Tap "Enable Calendar Access" on the Home screen
3. **Create Notes** – Add your first journal entry to help Alpine learn
4. **Ask Questions** – Go to the Console tab and ask about your day

---

## AI Core Progression

The AI Core evolves through **6 levels** based on your usage:

| Level | Name | Trigger |
|-------|------|---------|
| 0 | Dormant | Initial state |
| 1 | Spark | After calendar sync |
| 2 | Awareness | Open app on 3 different days |
| 3 | Pattern Recognition | Create 5 notes |
| 4 | Contextual | Ask first AI Console question |
| 5 | Predictive | Ask 10 questions or create 10 notes |

Each level brings:
- **Visual changes** to the AI Core (color, glow, animations)
- **Enhanced understanding** (in future ML implementations)

---

## Extending Alpine

### Replacing the Stub AI Engine

The current MVP uses `StubAIEngine`, which provides template-based responses. To integrate real AI:

#### Option A: On-Device CoreML Model

```swift
class CoreMLAIEngine: AIEngine {
    private let model: MLModel

    init() throws {
        // Load your .mlmodel or .mlmodelc
        self.model = try YourModel(configuration: MLModelConfiguration())
    }

    func answer(question: String, context: AIContext) async throws -> String {
        // 1. Tokenize input
        // 2. Construct prompt with RAG context
        // 3. Run inference
        // 4. Decode output
        // 5. Return response
    }
}
```

Then update `AppState.swift`:
```swift
let aiEngine: AIEngine = try! CoreMLAIEngine()
```

#### Option B: HTTP-Based LLM API

```swift
class HTTPAIEngine: AIEngine {
    private let apiKey: String
    private let endpoint = URL(string: "https://api.example.com/chat")!

    func answer(question: String, context: AIContext) async throws -> String {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let payload = [
            "question": question,
            "context": try JSONEncoder().encode(context)
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let (data, _) = try await URLSession.shared.data(for: request)
        // Parse and return response
    }
}
```

### Adding HealthKit Integration

1. **Add HealthKit capability** in Xcode project settings

2. **Update Info.plist:**
   ```xml
   <key>NSHealthShareUsageDescription</key>
   <string>Alpine uses your health data to provide personalized insights</string>
   ```

3. **Create `HealthService.swift`:**
   ```swift
   import HealthKit

   class HealthService: ObservableObject {
       private let healthStore = HKHealthStore()

       func requestAuthorization() async throws {
           let types: Set = [
               HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
               HKObjectType.quantityType(forIdentifier: .stepCount)!
           ]
           try await healthStore.requestAuthorization(toShare: [], read: types)
       }

       func fetchSleepData() async throws -> [HKCategorySample] {
           // Query sleep data
       }
   }
   ```

4. **Update `AIContext`** to include health metrics

### Adding Vector Embeddings for Semantic Search

For true RAG (Retrieval-Augmented Generation):

1. **Generate embeddings** for notes using CoreML
2. **Store in vector database** (e.g., SQLite with vector extension)
3. **Query by similarity** when building context for AI
4. **Pass top-k relevant notes** to the LLM

Example:
```swift
class EmbeddingsService {
    private let model: EmbeddingModel

    func embed(text: String) async throws -> [Float] {
        // Convert text to embedding vector
    }

    func findSimilar(to query: String, limit: Int) async throws -> [Note] {
        let queryEmbedding = try await embed(text: query)
        // Vector similarity search in database
    }
}
```

---

## Privacy & Security

Alpine is designed with **privacy-first principles**:

- ✅ **All data stored locally** (UserDefaults for MVP, CoreData/SQLite recommended for production)
- ✅ **No cloud sync** (yet)
- ✅ **No analytics or tracking**
- ✅ **Calendar and Health data never leaves device**

### Future Enhancements

- [ ] **End-to-end encryption** for notes
- [ ] **Secure enclave** for sensitive data
- [ ] **Optional iCloud sync** with E2E encryption
- [ ] **Export data** (JSON, CSV)

---

## Roadmap

### Phase 1: Core ML Integration (Q2 2025)
- [ ] Integrate small language model (SLM) via CoreML
- [ ] On-device embeddings for semantic search
- [ ] RAG pipeline for context-aware responses

### Phase 2: Enhanced Data Sources
- [ ] HealthKit integration (sleep, activity, heart rate)
- [ ] Files and documents ingestion
- [ ] Email and messages (with permission)

### Phase 3: Advanced Features
- [ ] Proactive notifications and suggestions
- [ ] Voice interface (Siri integration)
- [ ] Widgets for Today view
- [ ] Apple Watch companion app

### Phase 4: Community & Ecosystem
- [ ] Plugin system for custom data sources
- [ ] Open-source model training framework
- [ ] Community-contributed AI cores

---

## Technical Details

### Persistence

**Current (MVP):**
- `UserDefaults` for settings, AI Core state, and notes
- Simple JSON encoding/decoding

**Recommended for Production:**
- **CoreData** for structured storage and relationships
- **SQLite with GRDB** for SQL access and vector extensions
- **File-based storage** with encryption for large data

### Dependencies

Alpine MVP has **zero external dependencies** – only Apple frameworks:
- SwiftUI
- EventKit (Calendar)
- HealthKit (future)
- CoreML (future)

### Testing Strategy

**TODO:** Add comprehensive test coverage:
- [ ] Unit tests for services and view models
- [ ] UI tests for critical flows
- [ ] Snapshot tests for visual regression
- [ ] Performance tests for AI inference

---

## Contributing

This is currently a solo project, but contributions are welcome!

### Areas for Contribution

1. **CoreML Model Integration** – Help build/optimize on-device SLM
2. **UI/UX Enhancements** – Improve animations and interactions
3. **Data Sources** – Add support for more personal data
4. **Testing** – Write comprehensive test suite
5. **Documentation** – Improve guides and tutorials

---

## License

MIT License – See LICENSE file for details

---

## Acknowledgments

- **LCARS Design** – Inspired by Star Trek: The Next Generation UI
- **Apple HIG** – Following Human Interface Guidelines for iOS
- **Privacy-First AI** – Building on principles from local-first software movement

---

## Contact

For questions, feedback, or collaboration:
- Open an issue on GitHub
- Email: [your-email@example.com]

---

**Built with ❤️ for privacy-conscious AI enthusiasts**
