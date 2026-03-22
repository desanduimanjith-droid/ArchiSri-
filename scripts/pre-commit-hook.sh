#!/bin/bash
# Pre-commit hook to run tests locally before pushing
# Install: cp scripts/pre-commit-hook.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

set -e

echo "🧪 Running Flutter tests locally..."
cd frontEnd

# Run analysis
flutter analyze

# Run format check
dart format --set-exit-if-changed lib/ test/

# Run unit tests
flutter test

echo "✅ All tests passed! Ready to push."
cd ..
