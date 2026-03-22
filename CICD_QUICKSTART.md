# ArchiSri CI/CD Setup Quick Start

## What's Included

✅ **Flutter Testing & Building**
- Automated unit tests on every push
- Code analysis (flutter analyze)
- Code formatting checks
- Coverage reports
- APK and Web builds

✅ **Python Backend Testing**
- Tests on Python 3.9 & 3.10
- All three backend services validated

✅ **Firebase Deployment**
- Auto-deploy web to Firebase Hosting on main branch push

## Quick Setup

### Step 1: Push Workflows to GitHub
```bash
git add .github/
git commit -m "Add CI/CD workflows"
git push origin main
```

### Step 2: Add GitHub Secrets (for Firebase deployment)
Go to **Settings > Secrets and variables > Actions** and add:
- `FIREBASE_SERVICE_ACCOUNT`: Your Firebase service account JSON

### Step 3: View Pipeline Results
Go to **Actions** tab on GitHub to see workflow runs

## Local Testing

Before pushing, run locally:

```bash
# Option 1: Run the pre-commit hook
bash scripts/pre-commit-hook.sh

# Option 2: Run manually
cd frontEnd
flutter analyze
dart format --set-exit-if-changed lib/ test/
flutter test --coverage
```

## Docker Local Development

Run all backends locally with one command:

```bash
docker-compose up
```

This starts:
- Constructor backend: http://localhost:5000
- Marketplace: http://localhost:5001
- Blueprint Generator: http://localhost:5002

## Status Badges

Add to your README.md:

```markdown
![Flutter CI/CD](https://github.com/YOUR_USER/ArchiSri-/workflows/Flutter%20CI%2FCD%20Pipeline/badge.svg)

![Deploy Firebase](https://github.com/YOUR_USER/ArchiSri-/workflows/Deploy%20to%20Firebase%20Hosting/badge.svg)
```

## Branch Protection (Recommended)

1. Go **Settings > Branches**
2. Add rule for `main` branch:
   - ✓ Require status checks to pass
   - ✓ Require "Flutter Test & Analyze" to pass
   - ✓ Require PR reviews

## Next Steps

1. **Add Python Tests**: Add `test_*.py` files to backend folders
2. **Enable Codecov**: Sign up at codecov.io for coverage tracking
3. **Add Deployment**: Configure auto-deploy to App Store, Play Store, etc.
4. **Slack Notifications**: Add notifications on workflow failure
5. **Performance Analysis**: Add performance testing workflows

## Troubleshooting

**Tests failing on CI but passing locally?**
- Check Flutter/Python versions match
- Ensure all dependencies in requirements.txt/pubspec.yaml
- Check environment variables

**APK build not uploading?**
- Verify storage quota on GitHub Actions
- Check retention-days settings

**Firebase deploy failing?**
- Verify FIREBASE_SERVICE_ACCOUNT secret is set
- Check projectId in workflow matches your Firebase project
