# 🛡️ CyberSafe 2D

> **Age-Based Cybersecurity Awareness Game — Built with Flutter & BLoC**

CyberSafe 2D is a mobile-first educational game that teaches cybersecurity concepts through interactive missions tailored to three age tiers: Kids (7–10), Tweens (11–14), and Teens (15–18). Every session is fully volatile — no data is ever stored on device.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Architecture](#-architecture)
- [Age Tiers & Themes](#-age-tiers--themes)
- [Missions](#-missions)
- [State Management (BLoC)](#-state-management-bloc)
- [Navigation](#-navigation)
- [Privacy & Data Policy](#-privacy--data-policy)
- [Flutter Version](#-flutter-version)

---

## 🧭 Overview

CyberSafe 2D puts players into real-world cybersecurity scenarios — sorting suspicious messages, inspecting malicious URLs, escaping social engineering traps, and more. Each mission is designed for a specific age group with a matching visual theme and difficulty level.

The app is entirely session-based. When the app closes, everything is gone. No accounts, no cloud sync, no local storage — just pure learning.

---

## ✨ Features

- **3 Age Tiers** with distinct visual themes and mission content
- **6 Fully Playable Missions** — each with a unique game mechanic
- **BLoC State Management** — clean separation of UI and business logic
- **Built-in Flutter Navigation** — no go_router or third-party routing
- **100% Volatile Sessions** — zero persistence, zero tracking
- **Animated UI** — swipe gestures, card flips, falling sprites, dialogue trees
- **Real-Time Feedback** — every answer includes an explanation
- **Mission Results Screen** — score, grade (S/A/B/C/D), and learning summary

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.38.0 |
| Language | Dart 3.10.0 |
| State Management | `flutter_bloc` ^8.1.6 |
| Equality | `equatable` ^2.0.5 |
| Navigation | Flutter built-in `Navigator` |
| Persistence | ❌ None (intentional) |
| Routing | ❌ No go_router (intentional) |

---

## 📁 Project Structure

```
cybersafe_2d/
├── lib/
│   ├── main.dart                          # App entry point, BlocProvider root
│   │
│   ├── core/
│   │   ├── bloc/
│   │   │   ├── session_bloc.dart          # Main BLoC — handles all session logic
│   │   │   ├── session_event.dart         # SetUser, CompleteMission, ResetSession
│   │   │   └── session_state.dart         # SessionInitial, SessionActive
│   │   │
│   │   ├── constants/
│   │   │   └── app_constants.dart         # Username rules, timeouts
│   │   │
│   │   ├── models/
│   │   │   ├── user_session.dart          # UserSession model + AgeTier enum
│   │   │   └── mission.dart               # Mission model + MissionRepository
│   │   │
│   │   └── theme/
│   │       └── age_tier_theme.dart        # Per-tier color/font/gradient themes
│   │
│   ├── features/
│   │   ├── home/
│   │   │   └── home_page.dart             # Username entry + age tier selection
│   │   │
│   │   ├── dashboard/
│   │   │   └── dashboard_page.dart        # Mission hub, progress ring, session info
│   │   │
│   │   ├── game/
│   │   │   ├── game_screen.dart           # Mission router — maps ID → game widget
│   │   │   ├── game_scaffold.dart         # HUD: progress bar, timer, score badge
│   │   │   │
│   │   │   └── missions/
│   │   │       ├── k001_hero_message_sort/
│   │   │       │   └── hero_message_sort_game.dart
│   │   │       ├── k002_password_fortress/
│   │   │       │   └── password_fortress_game.dart
│   │   │       ├── t001_dm_threat_buster/
│   │   │       │   └── dm_threat_buster_game.dart
│   │   │       ├── t002_fake_friend_request/
│   │   │       │   └── fake_friend_request_game.dart
│   │   │       ├── n001_social_engineering_escape/
│   │   │       │   └── social_engineering_escape_game.dart
│   │   │       └── n002_deep_link_inspector/
│   │   │           └── deep_link_inspector_game.dart
│   │   │
│   │   └── results/
│   │       └── mission_results_page.dart  # Score, grade, learning explanation, retry
│   │
│   └── widgets/                           # Shared widgets (reserved for future use)
│
├── assets/                                # Asset directory (placeholder)
└── pubspec.yaml
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter `3.38.0` or higher
- Dart `3.10.0` or higher
- Android Studio / VS Code with Flutter extension
- A connected device or emulator

### Installation

**1. Clone or extract the project:**

```bash
cd cybersafe_2d
```

**2. Install dependencies:**

```bash
flutter pub get
```

**3. Run the app:**

```bash
# Debug mode
flutter run

# Release mode (Android)
flutter run --release

# Specific device
flutter run -d <device_id>
```

**4. Build APK (Android):**

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**5. Build for iOS:**

```bash
flutter build ios --release
```

### Verify Setup

```bash
flutter doctor
flutter --version
```

Expected output:
```
Flutter 3.38.0 • channel stable
Framework • revision a0e9b9dbf7
Dart 3.10.0
```

---

## 🏗️ Architecture

CyberSafe 2D follows a **Feature-First** folder structure with a clean separation between the core domain layer and UI features.

### Layer Overview

```
Presentation (Pages / Widgets)
        ↕  BlocBuilder / BlocProvider
BLoC Layer (SessionBloc)
        ↕  Events / States
Domain Layer (Models, Repository)
```

### Data Flow

```
User taps "Start" on HomePage
    → Dispatches SetUserEvent(username, ageTier) to SessionBloc
    → SessionBloc emits SessionActive(UserSession)
    → Navigator.pushReplacement → DashboardPage

User completes a mission
    → GameScreen calls onComplete(score) callback
    → Dispatches CompleteMissionEvent(missionId, score)
    → SessionBloc updates missionProgress map
    → Navigator.pushReplacement → MissionResultsPage

User resets session
    → Dispatches ResetSessionEvent
    → SessionBloc emits SessionInitial
    → Navigator.pushReplacement → HomePage
```

### Key Design Decisions

**No go_router.** All navigation uses Flutter's built-in `Navigator.push` and `Navigator.pushReplacement`. This keeps the codebase simple and avoids route configuration overhead for a game with a linear flow.

**No persistence layer.** `SessionBloc` is created fresh on every app launch via `BlocProvider` in `main.dart`. There is no `SharedPreferences`, `Hive`, `SQLite`, or any other storage. This is intentional — the app is designed for classroom and workshop use where a clean slate every session is a feature, not a bug.

**BLoC over Provider.** All state flows through `SessionBloc`. UI widgets use `BlocBuilder` to react to state changes. No `ChangeNotifier`, no `ValueNotifier`, no `setState` for shared state.

---

## 🎨 Age Tiers & Themes

Each age tier has a completely different visual identity applied through `AgeTierTheme`:

### 🌟 Kids (7–10 Years)
- **Style:** Bright, warm, cartoon-friendly
- **Colors:** Orange `#FF6B35` + Yellow `#FFD166` + Mint `#06D6A0`
- **Background:** Cream white `#FFF8F0`
- **Tone:** Fun, encouraging, simple vocabulary

### ⚡ Tweens (11–14 Years)
- **Style:** Neon-on-dark, social media aesthetic
- **Colors:** Purple `#6C63FF` + Pink `#FF6584` + Green `#43E97B`
- **Background:** Deep navy `#0F0F1A`
- **Tone:** Relatable, Instagram/TikTok references, moderate complexity

### 🔐 Teens (15–18 Years)
- **Style:** Cyberpunk / terminal hacker aesthetic
- **Colors:** Cyan `#00D4FF` + Blue `#0066FF` + Red `#FF4444`
- **Background:** Near-black `#050A14`
- **Tone:** Technical, realistic attack scenarios, advanced concepts

---

## 🎮 Missions

### Kids Tier (7–10)

| ID | Mission | Mechanic | Learning Goal |
|---|---|---|---|
| `k001` | 🦸 Hero Message Sort | Swipe/tap cards — Safe vs Danger | Spot strangers & unsafe messages |
| `k002` | 🏰 Password Fortress | Tap falling sprites (60s timer) | Create strong passwords |

**k001 — Hero Message Sort**
Players are shown 8 messages from various senders. They must classify each as Safe or Danger by tapping buttons or swiping. Incorrect answers trigger a shake animation and an explanation. Swipe left = Danger, swipe right = Safe.

**k002 — Password Fortress**
Characters representing strong password elements (uppercase letters, numbers, special symbols) fall from the top of the screen. Players tap the good ones to add them to their fortress and avoid the weak ones. Lives system (3 hearts) adds stakes.

---

### Tweens Tier (11–14)

| ID | Mission | Mechanic | Learning Goal |
|---|---|---|---|
| `t001` | 📱 DM Threat Buster | Swipe cards left (block) / right (reply) | Identify phishing DMs |
| `t002` | 🎭 Fake Friend Request | Flip card to reveal red flags | Detect catfishing attempts |

**t001 — DM Threat Buster**
8 Instagram-style DM cards are presented one at a time. Players swipe left to block a suspicious DM or right to reply to a safe one. Cards visually tilt and show overlay labels during the swipe. Includes real social engineering scenarios like sextortion and credential theft.

**t002 — Fake Friend Request**
5 social media profiles are shown. Players tap the card to flip it and reveal hidden red flags (new account age, follower ratio anomalies, suspicious username patterns). They then decide: Accept or Reject. Teaches catfishing detection and profile analysis.

---

### Teens Tier (15–18)

| ID | Mission | Mechanic | Learning Goal |
|---|---|---|---|
| `n001` | 🧠 Social Engineering Escape | Branching dialogue tree + 90s timer | Recognize manipulation tactics |
| `n002` | 🔍 Deep Link Inspector | Tap URL segments + zoom | Detect URL spoofing |

**n001 — Social Engineering Escape**
A realistic phone call scenario plays out as a branching dialogue tree. Players choose their responses from 2–3 options at each node. The timer creates urgency — mirroring the real social engineering tactic of pressuring victims. Wrong choices lead to "compromised" end states with explanations of what went wrong.

**n002 — Deep Link Inspector**
5 URLs are presented in a terminal-style display. Players tap individual URL segments (protocol, domain, path) to reveal tooltips explaining red flags — typosquatting, subdomain spoofing, HTTP instead of HTTPS, free TLDs (.tk). Double-tap zooms in for closer inspection. Players then declare: Safe or Malicious.

---

## 🧩 State Management (BLoC)

### SessionBloc

The single source of truth for the entire app session.

```dart
// Events
SetUserEvent(username: String, ageTier: AgeTier)
CompleteMissionEvent(missionId: String, score: int)
ResetSessionEvent()

// States
SessionInitial     // App just launched, no user set
SessionActive      // User is playing — contains UserSession
```

### UserSession Model

```dart
class UserSession {
  final String? username;
  final AgeTier? ageTier;
  final Map<String, int> missionProgress;  // missionId → score (0–100)

  double get overallProgress   // 0.0 → 1.0
  int    get completedMissions // count of missions with score > 0
}
```

### Accessing State in Widgets

```dart
// Read current state
BlocBuilder<SessionBloc, SessionState>(
  builder: (context, state) {
    if (state is SessionActive) {
      final session = state.session;
      // use session.username, session.ageTier, etc.
    }
    return const SizedBox();
  },
)

// Dispatch an event
context.read<SessionBloc>().add(const ResetSessionEvent());
```

---

## 🧭 Navigation

Navigation uses Flutter's built-in `Navigator` exclusively. No go_router, no auto_route, no named routes.

### Navigation Map

```
HomePage
  └─ (on Start) pushReplacement → DashboardPage
       └─ (on mission tap) push → GameScreen
            └─ (on complete) pushReplacement → MissionResultsPage
                 ├─ (Back to Hub) pushReplacement → DashboardPage
                 └─ (Try Again)   pushReplacement → GameScreen
  └─ (on New Session from Dashboard) pushReplacement → HomePage
```

### Example

```dart
// Navigate to dashboard (replace current route)
Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (_) => const DashboardPage()),
);

// Navigate to a game
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => GameScreen(mission: mission),
  ),
);
```

---

## 🔒 Privacy & Data Policy

CyberSafe 2D collects **zero data**. By design:

- No user accounts
- No network requests
- No local file writes
- No `SharedPreferences` or `Hive` usage
- No analytics or crash reporting SDKs
- Session data lives entirely in `SessionBloc` RAM

When the app is closed or the session is reset, all progress is permanently erased. This makes CyberSafe 2D safe for classroom use with minors and compliant with COPPA and GDPR by default.

---

## 📱 Flutter Version

This project targets and has been verified against:

```
Flutter 3.38.0 • channel stable
Framework • revision a0e9b9dbf7 (2025-11-11)
Engine • hash 9ba28611ee8004751cbf039b10d0720ab4ebe521
Dart 3.10.0 (build 3.10.0-290.4.beta)
DevTools 2.51.1
```

### pubspec.yaml — Key Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

dev_dependencies:
  bloc_test: ^9.1.7
  flutter_lints: ^4.0.0
```

---

## 🗺️ Roadmap (Future Work)

- [ ] Sound effects and background music per age tier
- [ ] Additional missions for each tier
- [ ] Difficulty scaling within missions
- [ ] Printable certificate of completion (PDF export)
- [ ] Educator dashboard mode (offline, local-only)
- [ ] Accessibility improvements (screen reader support, font scaling)
- [ ] Localization (Arabic, Hindi, Portuguese)

---

## 📄 License

This project is for educational and demonstration purposes.

---

*Built with Flutter • Powered by BLoC • Zero data stored*