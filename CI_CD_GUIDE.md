# CI/CD Pipeline Documentation

## Overview
This CI/CD pipeline automatically tests, analyzes, and builds your Flutter and Python applications on every push and pull request to `main` and `develop` branches.

## Jobs

### 1. Flutter Test & Analyze
- **Trigger**: On push/PR to main or develop
- **Steps**:
  - Checkout code
  - Setup Flutter 3.10.4
  - Install dependencies (`flutter pub get`)
  - Run `flutter analyze` (code analysis)
  - Check code formatting with `dart format`
  - Run unit tests with coverage
  - Upload coverage reports to Codecov

### 2. Flutter Build APK
- **Trigger**: Only runs after Flutter Test & Analyze passes
- **Steps**:
  - Build release APK
  - Upload artifact for 30 days

### 3. Flutter Build Web
- **Trigger**: Only runs after Flutter Test & Analyze passes
- **Steps**:
  - Build web version
  - Upload artifact for 30 days

### 4. Python Backend Tests
- **Trigger**: On push/PR to main or develop
- **Matrix**: Tests on Python 3.9 and 3.10
- **Steps**:
  - Tests all three backend services:
    - Engineer & Constructor Connect Backend
    - Blueprint Generator
    - Marketplace
  - Installs dependencies from requirements.txt
  - Run tests (commented: add pytest or unittest when ready)

### 5. Code Quality Check
- **Trigger**: On push/PR to main or develop
- **Steps**:
  - Run custom lint checks
  - Continues even if lint fails (warnings only)

## Setup Instructions

1. **Push `.github/workflows/ci_cd.yml` to your repository**
   ```bash
   git add .github/workflows/ci_cd.yml
   git commit -m "Add CI/CD pipeline"
   git push origin main
   ```

2. **Configure GitHub Secrets (optional, for deployments)**
   - Go to Settings > Secrets and variables > Actions
   - Add any sensitive data needed for deployments

3. **Enable Actions**
   - Go to Actions tab on GitHub
   - Enable workflows if not already enabled

4. **Add Tests to Backend**
   - Create `test_*.py` or `tests/` folder in each backend service
   - Add pytest to requirements.txt
   - Uncomment pytest lines in workflow

5. **Link Codecov (optional)**
   - Go to codecov.io and signup
   - Link your repository
   - Coverage reports will auto-upload

## Test Results
- View results in Actions tab on GitHub
- Click on workflow run to see detailed logs
- Artifacts (APK, Web build) available for 30 days

## Adding Coverage Reports
Uncomment the pytest commands in `python_backend_test` job:

```yaml
- name: Test {Service} Backend
  run: |
    python -m pip install --upgrade pip
    pip install -r requirements.txt pytest
    python -m pytest --cov=. --cov-report=xml
```

## Branch Protection Rules (Recommended)
1. On GitHub repository Settings > Branches
2. Add branch protection rule for `main`:
   - Require "Flutter Test & Analyze" to pass before merging
   - Require PR reviews before merge
   - Require status checks to pass

## Local Testing Before Push
Run locally to match CI behavior:

```bash
# Flutter
cd frontEnd
flutter analyze
dart format --set-exit-if-changed lib/ test/
flutter test --coverage

# Python
cd backend/engineer&constructor_connect_backend
python -m pip install -r requirements.txt
python -m pytest
```

## Next Steps
1. Add pytest tests to Python backends
2. Configure deployment step (Firebase Hosting, App Store, etc.)
3. Add notifications (Slack, email on failure)
4. Set up auto-deployment to staging/production
