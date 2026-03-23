![alt text](image.png)

# ArchiSri CI/CD Pipeline - Your Project

## Project Structure
```
ArchiSri-/
├── frontEnd/                    ← Flutter App (your 18 unit tests)
│   ├── lib/
│   ├── test/                    ← All your tests run here
│   └── pubspec.yaml
├── backend/
│   ├── engineer&constructor_connect_backend/  (Port 5000)
│   ├── blueprint-generator/                    (Port 5002)
│   └── marketPlace/                            (Port 5001)
└── .github/workflows/
    └── ci_cd.yml               ← Pipeline runs this
```

## Your Pipeline in Action

When you push code:

```
PUSH TO GITHUB
    ↓
┌─────────────────────────────────────┐
│ 1. FLUTTER TESTS (18 tests)         │
│    ✅ Analyze code                   │
│    ✅ Check formatting               │
│    ✅ Run all tests                  │
│    ✅ Upload coverage                │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ 2. PYTHON BACKENDS LINT             │
│    ✅ Constructor Connect (Port 5000)│
│    ✅ Blueprint Generator (Port 5002)│
│    ✅ Marketplace (Port 5001)        │
│    (Tests on Python 3.9 & 3.10)     │
└─────────────────────────────────────┘
    ↓ (only if tests pass)
┌─────────────────────────────────────┐
│ 3. BUILD RELEASES                   │
│    ✅ APK for Android                │
│    ✅ Web version                    │
│    (Available for 30 days)          │
└─────────────────────────────────────┘
    ↓
✅ COMPLETE - All tests passed
```

## What Each Backend Tests

### Constructor Connect (app.py)
- Flask app
- Requirements: Flask, SQLAlchemy, Flask-CORS, Werkzeug
- Port: 5000

### Blueprint Generator (app.py)
- Flask app with AI
- Requirements: Flask, Flask-CORS, OpenAI, python-dotenv
- Port: 5002

### Marketplace (marketPlace.py)
- Flask app with Stripe
- Requirements: Flask, Flask-CORS, Stripe
- Port: 5001

## Your Test Coverage

### Flutter Frontend
- ✅ 6 tests: IoT Service (data parsing, defaults, errors)
- ✅ 8 tests: Company Login (validation, error mapping)
- ✅ 4 tests: Marketplace Rating (calculation, edge cases)
- **Total: 18 passing tests**

## How to Use

### 1. First Time Setup
```bash
git add .github/
git commit -m "Add CI/CD pipeline - matches project structure"
git push
```

### 2. View Results
- Go to GitHub → Actions tab
- See pipeline running in real-time
- Download APK & Web build from artifacts

### 3. Local Testing (Before Push)
```bash
# Flutter
cd frontEnd
flutter test

# Python Backends
cd backend/engineer&constructor_connect_backend
python -m py_compile app.py
```

## Pipeline Triggers

✅ **Always runs on:**
- Push to `main` branch
- Push to `develop` branch
- Pull requests to `main` or `develop`

## Download Artifacts

After pipeline completes:
1. Go to Actions tab
2. Click latest run
3. Scroll to "Artifacts" section
4. Download:
   - `archisri-app.apk` (Android app)
   - `archisri-web-build` (Web version)

Available for **30 days**

## Status Check

Look for:
- ✅ Green checkmark = All tests passed
- ❌ Red X = Something failed
- Check logs for what went wrong

## Next Steps (Optional)

1. **Auto-deploy**: Firebase Hosting, Play Store
2. **Notifications**: Slack alerts on failure
3. **More tests**: Add pytest to Python backends
4. **Performance**: Track build times
