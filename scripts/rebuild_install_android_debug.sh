#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEVICE_ID="${1:-emulator-5554}"
ADB_BIN="${ADB_BIN:-$HOME/Library/Android/sdk/platform-tools/adb}"
PACKAGE="com.ourmatchwell.ourmatchwell_flutter"
ACTIVITY="com.ourmatchwell.ourmatchwell_flutter.MainActivity"

cd "$PROJECT_ROOT"

flutter clean
flutter pub get
flutter build apk --debug
flutter install -d "$DEVICE_ID" --debug
"$ADB_BIN" -s "$DEVICE_ID" shell am start -n "$PACKAGE/$ACTIVITY"

echo "Done: rebuilt and installed latest debug APK on $DEVICE_ID"
