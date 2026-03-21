# ArchiSri Backend Deployment Guide - Render

Complete step-by-step guide to deploy your backend services to Render and connect them to your Flutter app.

---

## **PHASE 1: PREPARATION (5 minutes)**

### Step 1: Create a Render Account
1. Go to https://render.com
2. Sign up with GitHub account (easiest option)
3. Click "Create" in the dashboard

---

## **PHASE 2: DEPLOY BLUEPRINT GENERATOR (10 minutes)**

**Service**: AI-powered blueprint generation using OpenAI  
**Result**: URL like `https://archisri-blueprint.onrender.com`

### Step 1: Create GitHub Repository (if not already done)
```bash
cd ArchiSri-
git init
git add .
git commit -m "Initial commit: ArchiSri backend"
git remote add origin https://github.com/YOUR_USERNAME/archisri-backend.git
git push -u origin main
```

### Step 2: Deploy Blueprint Generator Service
1. In Render dashboard, click **"New +"** → **"Web Service"**
2. Select **"Deploy an existing repository"** → Select your GitHub repo
3. Fill in the form:
   - **Name**: `archisri-blueprint` (or any name)
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `cd backend/blueprint-generator && python app.py`
   - **Runtime**: Leave as default
4. Click **"Create Web Service"** (waits ~3 minutes)

### Step 3: Add Environment Variables
1. Once deployed, go to **Settings** → **Environment**
2. Add these variables:
   ```
   OPENAI_API_KEY=sk-proj-your_actual_openai_key
   FLASK_ENV=production
   PORT=10000  (Render auto-assigns, this is a placeholder)
   ```
3. Click **"Save Changes"** → Service redeploys automatically

### Step 4: Get Your URL
- Your Blueprint Generator is now at: `https://archisri-blueprint.onrender.com`
- **Test it**: Open `https://archisri-blueprint.onrender.com/` in your browser
- You should see: `{"status": "Backend is running", ...}`

---

## **PHASE 3: DEPLOY CONSTRUCTOR CONNECT (10 minutes)**

**Service**: Main API connecting customers with constructors (has database)  
**Result**: URL like `https://archisri-constructor.onrender.com`

### Step 1: Deploy Constructor Connect Service
1. Click **"New +"** → **"Web Service"** again
2. Select same GitHub repository
3. Fill in the form:
   - **Name**: `archisri-constructor`
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `cd backend/engineer&constructor_connect_backend && python app.py`
4. Click **"Create Web Service"**

### Step 2: Add Environment Variables
1. Go to **Settings** → **Environment**
2. Add:
   ```
   FLASK_ENV=production
   PORT=10000  (auto-assigned)
   ```
3. Save changes

### Step 3: Get Your URL
- Constructor Connect is now at: `https://archisri-constructor.onrender.com`
- **Test it**: Open `https://archisri-constructor.onrender.com/api/health` in your browser
- You should see: `{"status": "healthy", ...}`

---

## **PHASE 4: DEPLOY MARKETPLACE (10 minutes)**

**Service**: Stripe payment processing  
**Result**: URL like `https://archisri-marketplace.onrender.com`

### Step 1: Deploy MarketPlace Service
1. Click **"New +"** → **"Web Service"**
2. Select same GitHub repository
3. Fill in:
   - **Name**: `archisri-marketplace`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `cd backend/marketPlace && python marketPlace.py`
4. Create

### Step 2: Add Environment Variables
1. Go to **Settings** → **Environment**
2. Add:
   ```
   STRIPE_SECRET_KEY=sk_live_your_actual_stripe_key
   FLASK_ENV=production
   BASE_URL=https://archisri-marketplace.onrender.com
   PORT=10000
   ```
3. Save

### Step 3: Get Your URL
- MarketPlace is now at: `https://archisri-marketplace.onrender.com`

---

## **PHASE 5: UPDATE FLUTTER APP (15 minutes)**

Now your backend is live! Update your Flutter app to use these URLs.

### Step 1: Find All API Calls in Flutter Code

In your Flutter `lib/` directory, look for files that make API requests. Common places:
- `iot_service.dart`
- `connection_Engineer.dart`
- `connection_Construction.dart`
- Model files

### Step 2: Create a Configuration File

Create `lib/config/api_config.dart`:

```dart
class ApiConfig {
  // Your deployed Render URLs
  static const String blueprintGeneratorUrl = 'https://archisri-blueprint.onrender.com';
  static const String constructorConnectUrl = 'https://archisri-constructor.onrender.com';
  static const String marketplaceUrl = 'https://archisri-marketplace.onrender.com';

  // Individual endpoints
  static const String blueprintEndpoint = '$blueprintGeneratorUrl/blueprint';
  static const String constructorsEndpoint = '$constructorConnectUrl/api/constructors';
  static const String requestsEndpoint = '$constructorConnectUrl/api/requests';
  static const String healthCheckEndpoint = '$constructorConnectUrl/api/health';
  static const String checkoutEndpoint = '$marketplaceUrl/create-checkout';
}
```

### Step 3: Update API Calls

Replace all hardcoded URLs with `ApiConfig`. Example:

**BEFORE:**
```dart
final response = await http.get(
  Uri.parse('http://127.0.0.1:8000/api/constructors')
);
```

**AFTER:**
```dart
final response = await http.get(
  Uri.parse(ApiConfig.constructorsEndpoint)
);
```

---

## **PHASE 6: BUILD APK (10 minutes)**

### Step 1: Update Flutter Dependencies
```bash
cd frontEnd
flutter pub get
```

### Step 2: Build Release APK
```bash
flutter build apk --release
```

### Step 3: Output Location
Your APK is at: `frontEnd/build/app/outputs/flutter-app-release.apk`

### Step 4: Test the APK
- Transfer to Android device
- Install: `adb install build/app/outputs/flutter-app-release.apk`
- Open app and test all features

---

## **TROUBLESHOOTING**

### Problem: "Service not responding"
- Check email from Render for errors
- Review logs in Render dashboard (Logs tab)
- Ensure environment variables are set correctly

### Problem: "API endpoint returns 404"
- Check exact endpoint URLs in your backend routes
- Verify CORS is enabled (it is in your code ✓)

### Problem: "Database errors"
- Constructor Connect uses SQLite (auto-created on first run)
- Render ephemeral storage means database resets on redeploy
- **Solution for production**: Switch to PostgreSQL later

### Problem: "OpenAI or Stripe errors"
- Verify API keys are correct in Render environment settings
- Check API key permissions in OpenAI/Stripe dashboards

---

## **NEXT STEPS - PRODUCTION READY**

✅ Backend deployed  
✅ Flutter app updated  
✅ APK built  

**Future improvements:**
1. **Database**: Switch from SQLite to PostgreSQL (free tier available on Render)
2. **Firestore sync**: Already configured in your code
3. **SSL/Domain**: Purchase custom domain at Namecheap (~$1-8/year), connect to Render
4. **Monitoring**: Set up Render alerts for service downtime

---

## **IMPORTANT: Keep Your URLs Safe**

Never commit `.env` files with real API keys!  
✅ Already in `.gitignore`

---

**Questions?** The backend is now live and ready for your Flutter app! 🚀
