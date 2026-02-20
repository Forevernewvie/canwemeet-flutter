# ISO-Compliant Feature Delivery Report

## 1. Requirements Definition

### Scope
- Add `Real-world Send Mode` in sentence detail.
- Add `Daily Review Reminder` in settings and app lifecycle.
- Preserve all existing behavior without regression.

### Quality Objectives
- ISO 9001: traceable change process with verifiable outputs.
- ISO/IEC 25010: improve functional suitability, reliability, maintainability, and usability.
- ISO/IEC 12207: requirements -> design -> implementation -> verification -> maintenance handoff.

### Functional Requirements
- FR-01: Provide deterministic tone variants (`Natural`, `Softer`, `More direct`).
- FR-02: Support copy/share for selected variant.
- FR-03: Support reminder enable/disable and time selection in settings.
- FR-04: Request notification permission safely and provide non-blocking guidance on denial.
- FR-05: Schedule exactly one daily reminder (stable notification ID).
- FR-06: Include due-count message when available; fallback otherwise.
- FR-07: Keep existing features and tests intact.

## 2. Functional Specification

### Real-world Send Mode
- Entry point: sentence detail screen.
- User selects tone variant via chips.
- App computes transformed text locally.
- User can copy or share transformed text.

### Daily Review Reminder
- Entry point: settings screen.
- User toggles reminder and picks local time.
- Controller requests permission on enable.
- Controller schedules or cancels local notification.
- App bootstrapper re-syncs on app start/resume and preference changes.

## 3. System Architecture Design

### Layering
- Presentation: settings and sentence detail UI.
- Application: `SentenceSendModeUseCase`, `ReviewReminderController`.
- Infrastructure: `flutter_local_notifications`, `share_plus`.
- Persistence: `PreferencesStore` (`SharedPreferences` + Isar mirror).

### SOLID Application
- SRP: tone transformation, scheduling orchestration, and UI responsibilities are separated.
- OCP/DIP: reminder logic depends on `ReviewReminderNotificationClient` abstraction.
- Testability: fake notification client isolates scheduling behavior in unit tests.

## 4. Data Structure Design

### Persisted Keys
- `review_reminder_enabled: bool`
- `review_reminder_hour: int`
- `review_reminder_minute: int`

### Configuration Separation
- Reminder defaults and notification channel values are in `core/config/review_reminder_config.dart`.
- User-facing feature text constants are in `core/constants/feature_texts.dart`.

## 5. API Specification

### Internal Application APIs
- `SentenceSendModeUseCase.textFor(source, variant) -> String`
- `ReviewReminderController.updateEnabled(enabled) -> Future<ReminderToggleResult>`
- `ReviewReminderController.updateTime(hour, minute) -> Future<void>`
- `ReviewReminderController.syncCurrentSettings() -> Future<void>`

### Infrastructure Contract
- `ReviewReminderNotificationClient.initialize()`
- `ReviewReminderNotificationClient.requestPermission()`
- `ReviewReminderNotificationClient.scheduleDaily(...)`
- `ReviewReminderNotificationClient.cancel(notificationId)`

## 6. Exception Handling Policy

### Error Points and Policy
- Permission denied: return `permissionDenied`, keep UX non-blocking.
- Plugin failure: catch and log error via `AppLogger`; avoid crash.
- Unsupported platforms/tests: use no-op notification client.
- Timezone resolution failure: fallback to UTC.

### Security Considerations
- No sensitive payload in notifications.
- Clipboard/share only uses user-selected sentence text.
- Permission is requested only on explicit user enable action.

### Performance Considerations
- Single stable notification ID prevents duplicate schedules.
- Signature-based sync avoids unnecessary rescheduling.
- Local deterministic transformation avoids network latency.

## 7. Test Cases

### Added Tests
- `test/sentence_send_mode_usecase_test.dart`
  - deterministic transformation
  - natural/softer/direct behavior
- `test/review_reminder_controller_test.dart`
  - permission denied path
  - successful schedule path
  - reschedule on time change
  - cancel when disabled
- `test/review_reminder_preferences_test.dart`
  - default reminder values
  - persistence across store recreation

## 8. Code Implementation

### Core Additions
- `lib/domain/usecases/sentence_send_mode_usecase.dart`
- `lib/core/notifications/review_reminder_controller.dart`
- `lib/app/review_reminder_bootstrapper.dart`
- `lib/core/config/review_reminder_config.dart`
- `lib/core/constants/feature_texts.dart`

### Integrations
- `lib/features/sentence_detail/sentence_detail_view.dart`
- `lib/features/settings/settings_view.dart`
- `lib/core/persistence/preferences_store.dart`
- `lib/app/app.dart`
- `android/app/src/main/AndroidManifest.xml`
- `pubspec.yaml`, `pubspec.lock`

## 9. Code Verification Report

### Static Analysis
- Command: `flutter analyze`
- Result: pass (no issues)

### Test Execution
- Command: `flutter test`
- Result: pass (all tests)

### Regression Status
- Existing tests remain green.
- New feature tests are green.

## 10. Maintenance Guide

### Operational Checklist
- Run `flutter analyze` and `flutter test` before each merge.
- Validate permission-denied and permission-granted flows on real devices.
- Verify reminder schedule after app restart and resume.

### Extension Strategy
- Add localization by replacing `FeatureTexts` constants with i18n resources.
- Extend reminder recurrence policy in `ReviewReminderNotificationClient`.
- Keep environment-driven defaults in `review_reminder_config.dart`.

### Change Control
- Any reminder behavior change should include:
  - updated controller tests
  - updated settings UX validation
  - explicit regression check on existing features
