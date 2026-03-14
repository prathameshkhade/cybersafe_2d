# 🛡️ CyberSafe 2D

> A mobile-first cybersecurity education game built with Flutter — teaching real-world digital safety through interactive missions across three age groups.

<br>

## What is CyberSafe 2D?

CyberSafe 2D puts players into real cybersecurity scenarios — spotting phishing emails, analysing suspicious profiles, escaping social engineering traps, and responding to live incidents. Every mission is purpose-built for a specific age group with a matching visual theme and difficulty.

The app is **100% session-based**. No accounts, no cloud sync, no local storage — just pure learning. When the app closes, everything resets.

<br>

## 🎮 Missions

### 🌟 Kids (7–10)

| # | Mission | Mechanic | Teaches |
|---|---|---|---|
| k001 | 🦸 Hero Message Sort | Swipe cards — Safe vs Danger | Spotting unsafe messages from strangers |
| k002 | 🏰 Password Fortress | Tap falling sprites — 60s timer | Building strong passwords |
| k003 | 🔒 Privacy Shield | Swipe cards — Private vs Safe to Share | What personal info to keep private |
| k004 | 🚨 Danger Detector | Traffic light tap — Green / Yellow / Red | Recognising online danger levels |

### ⚡ Tweens (11–14)

| # | Mission | Mechanic | Teaches |
|---|---|---|---|
| t001 | 📱 DM Threat Buster | Swipe left (block) / right (reply) | Identifying phishing DMs |
| t002 | 🎭 Fake Friend Request | Flip card to reveal red flags | Detecting catfishing attempts |
| t003 | 📧 Phishing Email Spotter | Tap red flags + Phishing / Legit verdict | Spotting phishing emails |
| t004 | 🔐 Two Factor Hero | Pick the safest login method | Understanding 2FA and password strength |

### 🔐 Teens (15–18)

| # | Mission | Mechanic | Teaches |
|---|---|---|---|
| n001 | 🧠 Social Engineering Escape | Branching dialogue + 90s timer | Recognising manipulation tactics |
| n002 | 🔍 Deep Link Inspector | Tap URL segments + zoom | Detecting URL spoofing |
| n003 | 🕵️ OSINT Exposure Scanner | Tap info chips + Low / High risk verdict | How public info enables location tracking |
| n004 | 🛡️ Incident Response | Tap-to-order timed response steps | Executing correct incident response |

<br>

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.38.0 |
| Language | Dart 3.10.0 |
| State Management | `flutter_bloc` ^8.1.6 |
| Equality | `equatable` ^2.0.5 |
| Navigation | Flutter built-in `Navigator` |
| Persistence | ❌ None — intentional |

<br>

## 🚀 Setup & Installation

### Prerequisites

- Flutter `3.38.0` or higher
- Dart `3.10.0` or higher
- Android Studio or VS Code with the Flutter extension
- A connected device or emulator

### Run Locally

```bash
# 1. Clone the repo
git clone https://github.com/prathameshkhade/cybersafe_2d.git
cd cybersafe_2d

# 2. Install dependencies
flutter pub get

# 3. Run in debug mode
flutter run

# 4. Run in release mode
flutter run --release
```

### Build

```bash
# Android — split APKs by architecture
flutter build apk --release --split-per-abi

# iOS
flutter build ios --release --no-codesign
```

### GitHub Codespaces

This repo includes a devcontainer for instant setup in GitHub Codespaces:

1. Open the repo on GitHub
2. Click **Code → Codespaces → Create codespace**
3. Wait for the container to build — Flutter is installed automatically
4. Run the app on web:

```bash
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0
```

Set port `8080` to **Public** in the Codespace PORTS tab to preview in your browser.

<br>

## 🔄 CI/CD Pipeline

Every push to `main` automatically:

1. **Builds Android** — produces 3 split APKs (arm64-v8a, armeabi-v7a, x86_64)
2. **Builds iOS** — compiles release build with no codesign
3. **Creates a GitHub Release** — attaches all build artifacts

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `KEYSTORE_BASE64` | Base64-encoded Android keystore `.jks` file |
| `STORE_PASSWORD` | Keystore store password |
| `KEY_ALIAS` | Key alias inside the keystore |
| `KEY_PASSWORD` | Key password |

<br>

## 🔒 Privacy by Design

CyberSafe 2D collects **zero data**:

- No user accounts or login
- No network requests
- No local file writes or `SharedPreferences`
- No analytics or crash reporting
- All session state lives in RAM — erased on close

This makes it safe for classroom use with minors and compliant with COPPA and GDPR by default.

<br>

## 👥 Contributors

| Role | Name |
|---|---|
| 🎨 Designer & Developer | [@prathameshkhade](https://github.com/prathameshkhade) |
| 🛠️ Mission Development & CI/CD | [@amanmulla3291](https://github.com/amanmulla3291) |

<br>

---

*Built with Flutter · Powered by BLoC · Zero data stored · 12 missions across 3 age tiers*