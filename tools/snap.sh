#!/bin/zsh
# Light/dark sample windows. Never enumerate, capture, or arrange real windows.
set -euo pipefail
app="${SNAPPER_APP_PATH:-$HOME/Applications/Snapper.app}"
store=/tmp/Snapper-test.store
shots=/tmp/Snapper-shots
rm -f "$store" "$store-shm" "$store-wal"
rm -rf "$shots"
APP_STORE="$store" APP_SEED=1 APP_SNAPSHOT="$shots" "$app/Contents/MacOS/Snapper" -ApplePersistenceIgnoreState YES
