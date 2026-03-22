# SUPER DETAILED DEPLOYMENT GUIDE - FOR COMPLETE BEGINNERS

This guide walks through EVERY single click and action needed.

---

# PART 1: GET YOUR API KEYS (15 minutes)

## Step 1A: Get OpenAI API Key

### What is it?
An API key is like a password that lets your app talk to OpenAI's AI services.

### How to get it:

**Step 1:** Open browser and go to: https://platform.openai.com/api-keys

**Step 2:** You'll see a sign-in page
- Click "Sign up" or "Sign in" (use email or Google)
- Create account if needed
- Complete email verification

**Step 3:** After login, you're on the API Keys page
- Look for red button that says "Create new secret key"
- Click it

**Step 4:** You'll see a popup with your key (looks like: `sk-proj-abcd1234...`)
- Click the copy icon or select all and copy
- **SAVE THIS SOMEWHERE SAFE** (notepad, password manager)
- ⚠️ NEVER share this key with anyone!

**You now have:** `OPENAI_API_KEY = sk-proj-xxxxx`

---

## Step 1B: Get Stripe API Key

### What is it?
A key that lets your app process payments.

### How to get it:

**Step 1:** Open browser and go to: https://dashboard.stripe.com/login

**Step 2:** Sign in or create account
- Use email to sign up
- Verify email

**Step 3:** You're now on Stripe Dashboard
- On the left sidebar, find "Developers" → Click it
- Click "API keys"

**Step 4:** You'll see two keys: Publishable and Secret
- Find the one that starts with `sk_live_` or `sk_test_`
- This is your **Secret Key**
- Click copy icon next to it
- **SAVE THIS TOO**

**You now have:** `STRIPE_SECRET_KEY = sk_live_xxxxx`

---

# PART 2: CREATE RENDER ACCOUNT (5 minutes)

## Step 2A: Sign Up on Render

**Step 1:** Open browser: https://render.com

**Step 2:** Click "Sign Up" button (top right)

**Step 3:** Choose login method (pick one):
- ✅ **EASIEST:** Click "Continue with GitHub"
  - You'll be asked to authorize (click Allow)
  - You're signed up!
  
- Alternative: Use email (more steps, but works too)

**Step 4:** Click "Create" button in dashboard
- You'll see dashboard with "New +" button

**You're now on Render!** ✅

---

# PART 3: DEPLOY SERVICE #1 - BLUEPRINT GENERATOR (10 minutes)

This service generates architectural blueprints using AI.

## Step 3A: Create First Service

**Step 1:** In Render dashboard, click **"New +"** button (top left)

**Step 2:** You'll see menu options, click: **"Web Service"**

**Step 3:** You'll see "Build and deploy from a Git repository"
- Make sure **"Connect your GitHub repository"** is showing
- If not, click it
- Click the repository: `ArchiSri-`

**Step 4:** After selecting repo, fill in this form:

```
Name:                    archisri-blueprint
Environment:             Python 3
Build Command:           pip install -r requirements.txt  
Start Command:           cd backend/blueprint-generator && python app.py
Publish port:            Leave empty
Instance Type:           Free
Auto-Deploy:             Yes (recommended)
```

Let me explain what each means:
- **Name:** What you want to call this service
- **Environment:** Python 3 (your backend language)
- **Build Command:** Install packages needed
- **Start Command:** How to start the service
- **Auto-Deploy:** Automatically redeploys when you push to GitHub

**Step 5:** At the bottom, click **"Create Web Service"** (blue button)

**Step 6:** Wait ~3-5 minutes
- You'll see "Build in Progress" with logs scrolling
- Wait until you see "Build successful" or "Running"
- The service is now LIVE! ✅

**Step 7:** Get your URL
- At the top, you'll see a URL like: `https://archisri-blueprint.onrender.com`
- **COPY THIS** and save it somewhere
- This is your Blueprint Generator URL!

## Step 3B: Add API Key to This Service

**Step 1:** In the service page (you just created), scroll down to find **"Environment"** section

**Step 2:** Click **"Add Environment Variable"**

**Step 3:** You'll see two boxes:
- **Left box (Key):** Type `OPENAI_API_KEY`
- **Right box (Value):** Paste your OpenAI key (from Part 1A)

**Step 4:** Click "Save" (bottom right of the variable)

**Step 5:** The service restarts automatically ✅

---

# PART 4: DEPLOY SERVICE #2 - CONSTRUCTOR CONNECT (10 minutes)

This service connects customers with construction professionals.

## Step 4A: Create Second Service

**Step 1:** Back in Render dashboard, click **"New +"** again

**Step 2:** Click **"Web Service"**

**Step 3:** Select repository `ArchiSri-`

**Step 4:** Fill in the form:

```
Name:                    archisri-constructor
Environment:             Python 3
Build Command:           pip install -r requirements.txt
Start Command:           cd backend/engineer\&constructor_connect_backend && python app.py
Publish port:            Leave empty
Instance Type:           Free
Auto-Deploy:             Yes
```

⚠️ **IMPORTANT:** Make sure to use the correct folder name with the `&` character (or just copy-paste from the guide above to avoid the backslash issue)

**Step 5:** Click **"Create Web Service"**

**Step 6:** Wait ~3-5 minutes for build to complete

**Step 7:** Get your URL and SAVE IT
- URL will look like: `https://archisri-constructor.onrender.com`

## Step 4B: Add Environment Variables

**Step 1:** On this service page, go to **"Environment"**

**Step 2:** Add TWO variables:

### Variable 1:
- **Key:** `FLASK_ENV`
- **Value:** `production`
- Click Save

### Variable 2:
- **Key:** `PORT`
- **Value:** Leave empty (Render assigns automatically)

**Step 3:** Service restarts ✅

---

# PART 5: DEPLOY SERVICE #3 - MARKETPLACE (10 minutes)

This service handles payment processing.

## Step 5A: Create Third Service

**Step 1:** Click **"New +"** in Render dashboard

**Step 2:** Click **"Web Service"**

**Step 3:** Select repository `ArchiSri-`

**Step 4:** Fill in the form:

```
Name:                    archisri-marketplace
Environment:             Python 3
Build Command:           pip install -r requirements.txt
Start Command:           cd backend/marketPlace && python marketPlace.py
Publish port:            Leave empty
Instance Type:           Free
Auto-Deploy:             Yes
```

**Step 5:** Click **"Create Web Service"**

**Step 6:** Wait ~3-5 minutes

**Step 7:** Get your URL and SAVE IT
- URL will look like: `https://archisri-marketplace.onrender.com`

## Step 5B: Add API Key

**Step 1:** On this service page, go to **"Environment"**

**Step 2:** Add TWO variables:

### Variable 1:
- **Key:** `STRIPE_SECRET_KEY`
- **Value:** Paste your Stripe key (from Part 1B)
- Click Save

### Variable 2:
- **Key:** `BASE_URL`
- **Value:** `https://archisri-marketplace.onrender.com`
- Click Save

**Step 3:** Service restarts ✅

---

# PART 6: TEST YOUR DEPLOYED SERVICES (5 minutes)

## Test 1: Blueprint Generator

**Step 1:** Open browser and go to:
```
https://archisri-blueprint.onrender.com/
```

**Step 2:** You should see this in the page:
```json
{
  "status": "Backend is running",
  "project": "ArchiSir - AI Blueprint Service (OpenAI Version)"
}
```

✅ **If you see this, service is WORKING!**

---

## Test 2: Constructor Connect

**Step 1:** Open browser and go to:
```
https://archisri-constructor.onrender.com/api/health
```

**Step 2:** You should see:
```json
{
  "status": "healthy",
  "message": "Constructor Connect API is running"
}
```

✅ **If you see this, service is WORKING!**

---

## Test 3: Marketplace

**Step 1:** Open browser and go to:
```
https://archisri-marketplace.onrender.com/
```

**Step 2:** It might show nothing or an error - that's OK (no "/" endpoint)
- The important thing is it didn't timeout

✅ **Service is WORKING!**

---

# PART 7: UPDATE YOUR FLUTTER APP (20 minutes)

Now your backend is live! Update your Flutter app to use these URLs.

## Step 7A: Create API Configuration File

**Step 1:** Open VS Code
- Open your Flutter project: `/Users/meghana/Desktop/ggpp/ArchiSri-/frontEnd`

**Step 2:** Create new folder
- Right-click on `lib/` folder
- Click "New Folder"
- Name it: `config`

**Step 3:** Create new file
- Right-click on `lib/config/`
- Click "New File"
- Name it: `api_config.dart`

**Step 4:** Copy this code into the file:

```dart
class ApiConfig {
  // Your deployed Render URLs
  // PASTE YOUR RENDER URLS HERE:
  
  static const String blueprintGeneratorUrl = 'https://archisri-blueprint.onrender.com';
  static const String constructorConnectUrl = 'https://archisri-constructor.onrender.com';
  static const String marketplaceUrl = 'https://archisri-marketplace.onrender.com';

  // Individual endpoints
  static const String blueprintEndpoint = '$blueprintGeneratorUrl/blueprint';
  static const String constructorsEndpoint = '$constructorConnectUrl/api/constructors';
  static const String constructorDetailEndpoint = '$constructorConnectUrl/api/constructors'; // Add ID at runtime
  static const String requestsEndpoint = '$constructorConnectUrl/api/requests';
  static const String healthCheckEndpoint = '$constructorConnectUrl/api/health';
  static const String checkoutEndpoint = '$marketplaceUrl/create-checkout';
}
```

**Step 5:** Replace the URLs with YOUR Render URLs:
- Change `archisri-blueprint.onrender.com` to your real URL
- Change `archisri-constructor.onrender.com` to your real URL
- Change `archisri-marketplace.onrender.com` to your real URL

---

## Step 7B: Update Existing Code to Use These URLs

**Step 1:** Find all files that make API calls

**Common files:** (search in VS Code)
- `connection_Engineer.dart`
- `connection_Construction.dart`
- `iot_service.dart`
- `marketPlace.dart`

**Step 2:** For each file, find lines like:
```dart
Uri.parse('http://127.0.0.1:8000/api/constructors')
Uri.parse('http://127.0.0.1:5002/blueprint')
```

**Step 3:** Replace with:
```dart
// At the top of file, add:
import 'package:your_app/config/api_config.dart';

// Then use:
Uri.parse(ApiConfig.constructorsEndpoint)
Uri.parse(ApiConfig.blueprintEndpoint)
```

---

# PART 8: BUILD APK (10 minutes)

Finally, build your app for Android!

## Step 8A: Prepare Flutter

**Step 1:** Open Terminal (in VS Code)
- Top menu: Terminal → New Terminal
- Or keyboard: Ctrl + `

**Step 2:** Navigate to frontend folder:
```bash
cd /Users/meghana/Desktop/ggpp/ArchiSri-/frontEnd
```

**Step 3:** Get latest dependencies:
```bash
flutter pub get
```

---

## Step 8B: Build APK

**Step 1:** In terminal, run:
```bash
flutter build apk --release
```

**Step 2:** Wait ~5-10 minutes
- You'll see logs scrolling
- Final message: "✅ Built build/app/outputs/flutter-app-release.apk"

**Step 3:** Your APK is ready at:
```
frontEnd/build/app/outputs/flutter-app-release.apk
```

---

## Step 8C: Test the APK (Optional)

If you have an Android device:

**Step 1:** Connect device via USB cable

**Step 2:** In terminal, run:
```bash
flutter install
```

**Step 3:** App opens on your phone - test it! 🎉

---

# SUMMARY OF YOUR 3 LIVE URLS

After you complete all steps, you'll have:

```
🔗 Blueprint Generator: https://archisri-blueprint.onrender.com
🔗 Constructor Connect:  https://archisri-constructor.onrender.com
🔗 Marketplace:          https://archisri-marketplace.onrender.com
```

These are your LIVE backend services! 🚀

---

# TROUBLESHOOTING

## "Service says 'Failed to start'"
- Go to service → Logs (at bottom)
- Look for red error messages
- Common cause: Wrong Start Command (typo in folder name)

## "API returns 404"
- Double-check your endpoint URLs
- Make sure you used correct Render URLs in Flutter

## "Service keeps restarting"
- Check environment variables
- Make sure API keys are correct format

## "APK won't install"
- Make sure Android version matches (API 21+)
- Try: `flutter clean` then `flutter build apk --release` again

---

**You're ready! Start with Part 1 and follow each step.** 🎯

When you get stuck on any step, tell me which step and I'll help! 💪
