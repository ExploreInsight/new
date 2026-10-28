#!/bin/zsh
# Run on a temporary store; never reset the user's saved application state.
set -euo pipefail
app="${SNAPPER_APP_PATH:-$HOME/Applications/Snapper.app}"
store=/tmp/Snapper-self.store
rm -f "$store" "$store-shm" "$store-wal"
APP_STORE="$store" "$app/Contents/MacOS/Snapper" -ApplePersistenceIgnoreState YES --selftest
