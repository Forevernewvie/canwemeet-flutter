# Our Match Well (우리 제법 잘 어울려) - Flutter MVP

Last updated: 2026-02-21

## 1. Project Overview

Our Match Well is a Flutter mobile MVP for Korean users who want to communicate naturally with an English-speaking partner.

Current product focus:
- Daily practical learning with **3 sentences + 3 patterns**
- Fast reuse in real conversations
- Habit loop through favorites, review queue, streak, and daily reminder

This repository is implementation-first and currently free-only MVP.

## 2. MVP Scope (What Exists / What Is Intentionally Excluded)

What exists:
- Onboarding (multi-step carousel, skip, complete)
- 3-tab app shell: Today / Explore / My Library
- Sentence detail with send mode (tone variants, copy, share)
- Local daily review reminder (toggle + time + permission-safe handling)
- User-controlled appearance mode (System / Light / Dark)
- AdMob banner + UMP consent flow

Intentionally excluded:
- Premium/paywall/subscription/purchase flows
- AI backend chat features (not connected in this codebase)
- Remote manifest/content update logic (client exists, network behavior is stubbed)

## 3. Core Features

- Onboarding
  - `PageView` multi-step flow
  - `건너뛰기` (skip) and completion persistence
- 3 tabs: Today / Explore / My Library
  - Preserved route structure and shell navigation
- Sentence Detail send mode
  - Tone variants: `Natural`, `Softer`, `More direct`
  - Deterministic local text transform (`SentenceSendModeUseCase`)
  - Copy to clipboard + system share for selected variant
- Daily review reminder
  - Settings toggle + time picker
  - Permission-safe behavior (denied -> non-blocking guidance)
  - Stable notification ID and single daily schedule sync
- Appearance mode
  - Settings control for `System`, `Light`, `Dark`
  - Persisted preference and immediate theme update

## 4. Design System & Theming

Central theme source:
- `/Users/jaebinchoi/Desktop/OurMatchWellFlutter/lib/app/theme.dart`

Pencil source of truth:
- `/Users/jaebinchoi/Desktop/OurMatchWellFlutter/docs/design/our_match_well_mvp.pen`

Light/Dark tokens (implemented in `AppColors` + `ThemeData`):
- Light key colors: `bg #F4F0E9`, `card #FFFDF9`, `accent #2F8E63`, `accentWarm #D88B66`, `text #1A1918`
- Dark key colors: `bg #141311`, `card #1A1815`, `accent #49A97C`, `accentWarm #E3A17F`, `text #F2EDE6`
- Spacing scale: `4 / 8 / 12 / 16 / 24 / 32`
- Radius scale: `8 / 12 / 16 / 24`
- Shadow levels: `l0 / l1 / l2` (`AppShadows`)

Free-only design policy:
- No premium/paywall/purchase/subscription UI is part of this MVP.

## 5. Tech Stack & Architecture

- Flutter + Dart (`sdk: ^3.11.0`, CI pinned Flutter `3.41.1`)
- State management: `flutter_riverpod` (+ `ChangeNotifier` store for preferences)
- Routing: `go_router` (`StatefulShellRoute.indexedStack`)
- Persistence:
  - `shared_preferences` for user settings/state
  - Isar migration/dual-path support (`isar_community`)
  - File cache for content payloads
- Notifications: `flutter_local_notifications` + `timezone` + `flutter_timezone`
- Sharing: `share_plus`
- Ads/consent: `google_mobile_ads` + UMP SDK

Architecture style:
- Feature-first UI modules under `lib/features/*`
- Core services under `lib/core/*`
- Domain models/use-cases under `lib/domain/*`
- Reusable UI components under `lib/ui_components/*`

## 6. Local Setup

Prerequisites:
- Flutter SDK (stable)
- Dart SDK compatible with `^3.11.0`
- Android Studio + Android SDK (for Android)
- Xcode (for iOS, macOS only)
- Java 17 (required by Android build/CI)

Install dependencies:

```bash
cd /Users/jaebinchoi/Desktop/OurMatchWellFlutter
flutter pub get
```

Run app:

```bash
flutter run
```

Run specific device:

```bash
flutter devices
flutter run -d emulator-5554
```

## 7. Build & Install (Android)

`flutter_local_notifications` requires Android core library desugaring, already configured in:
- `/Users/jaebinchoi/Desktop/OurMatchWellFlutter/android/app/build.gradle.kts`
  - `isCoreLibraryDesugaringEnabled = true`
  - `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")`

Rebuild + reinstall debug APK on emulator:

```bash
cd /Users/jaebinchoi/Desktop/OurMatchWellFlutter
scripts/rebuild_install_android_debug.sh emulator-5554
```

Manual equivalent:

```bash
flutter clean
flutter pub get
flutter build apk --debug
flutter install -d emulator-5554 --debug
```

## 8. Testing & Quality Gates

Run static analysis:

```bash
flutter analyze
```

Run full tests:

```bash
flutter test -j 1
```

Run key feature tests:

```bash
flutter test test/sentence_send_mode_usecase_test.dart
flutter test test/review_reminder_controller_test.dart
flutter test test/review_reminder_preferences_test.dart
flutter test test/appearance_preferences_test.dart
flutter test test/appearance_theme_mode_mapping_test.dart
flutter test test/settings_appearance_interaction_test.dart
```

## 9. CI/CD

CI workflow:
- File: `/Users/jaebinchoi/Desktop/OurMatchWellFlutter/.github/workflows/ci.yml`
- Triggers:
  - `pull_request`
  - `push` on `main` and `codex/**`
  - `workflow_dispatch`
- Steps: `flutter pub get` -> `flutter analyze` -> `flutter test -j 1`

Release workflow:
- File: `/Users/jaebinchoi/Desktop/OurMatchWellFlutter/.github/workflows/release.yml`
- Triggered by tag push (`v*`) or manual dispatch
- Builds signed Android AAB and uploads to Google Play Internal track
- Requires signing + Play service-account secrets at runtime

## 10. Repository Structure (Important Folders)

```text
lib/
  app/                    # App root, router, shell, bootstrappers, theme
  core/
    ads/                  # AdMob + UMP consent
    config/               # Reminder constants and runtime config keys
    content/              # Content loading/filtering/repository
    notifications/        # Reminder scheduling controller/client
    persistence/          # SharedPreferences, Isar engine, file cache
    support/              # Logging/runtime support
  domain/
    models/               # Sentence, Pattern, ScenarioTag
    usecases/             # Today pack + send mode transforms
  features/
    onboarding/ today/ explore/ sentence_detail/ my_library/ settings/
  ui_components/          # Reusable cards, banners, states, search/top bar
assets/data/              # Local JSON datasets
test/                     # Unit/widget/smoke tests
docs/design/              # Pencil design source (.pen)
scripts/                  # Local developer automation scripts
distribution/             # Play upload notes and store assets
```

## 11. Troubleshooting

Stale APK or UI mismatch after changes:

```bash
cd /Users/jaebinchoi/Desktop/OurMatchWellFlutter
scripts/rebuild_install_android_debug.sh emulator-5554
```

If stale install persists:

```bash
adb -s emulator-5554 uninstall com.ourmatchwell.ourmatchwell_flutter
scripts/rebuild_install_android_debug.sh emulator-5554
```

If reminder notifications do not appear:
- Verify app notification permission in system settings
- Check reminder toggle/time in Settings
- Reopen app (bootstrapper resyncs schedule on resume/settings change)

## 12. Security / Release Notes

- Do not commit signing files:
  - `android/key.properties`
  - `android/upload-keystore.jks`
- Release build enforces signing config and rejects missing/invalid AdMob app ID.
- Keep secrets only in GitHub Actions Secrets:
  - `ANDROID_UPLOAD_KEYSTORE_BASE64`
  - `ANDROID_KEYSTORE_PASSWORD`
  - `ANDROID_KEY_ALIAS`
  - `ANDROID_KEY_PASSWORD`
  - `PLAY_SERVICE_ACCOUNT_JSON`
- Keep MVP free-only policy in UI/content updates:
  - No premium/paywall/subscription/purchase flows.
