#!/bin/bash
# Pre-commit hook to run frontend checks locally before pushing.
# Install: cp scripts/pre-commit-hook.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

set -euo pipefail

# Always run from the repository root, even when hook is invoked from .git/hooks.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Running Flutter checks..."
cd "${REPO_ROOT}/frontEnd"

# Ensure dependencies are available.
flutter pub get

# Keep analyze/format informative (non-blocking), same as CI behavior.
flutter analyze || true
dart format --set-exit-if-changed lib/ test/ || true

# Tests remain the gate.
flutter test

echo "All tests passed. Ready to commit."
