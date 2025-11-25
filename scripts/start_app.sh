#!/bin/zsh

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "[1/3] Running flutter pub get..."
flutter pub get

DEVICE_FLAG="${1:-}"

echo "[2/3] Building & running app..."
if [[ -n "$DEVICE_FLAG" ]]; then
  flutter run -d "$DEVICE_FLAG"
else
  flutter run
fi

