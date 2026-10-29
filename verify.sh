#!/usr/bin/env bash
# Deterministic verifier for the ShopCart RL sample task.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP="$ROOT/app"

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter not found on PATH" >&2
  exit 127
fi

cd "$APP"
flutter pub get
flutter analyze --no-fatal-infos
flutter test --reporter compact
echo "VERIFY_OK"
