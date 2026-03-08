# 🔗 API Integration Guide - Step by Step

This guide shows exactly how to integrate the Flutter app with the Node.js backend once it's ready.

---

## 📝 Quick Integration Checklist

When your Node.js backend is ready, follow these steps:

### ✅ Step 1: Update pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.1.0  # ADD THIS LINE
```

Then run:
```bash
flutter pub get
```

### ✅ Step 2: Update API Service BaseUrl
**File:** `lib/services/api_service.dart`

Change this:
```dart
static const String baseUrl = 'http://your-nodejs-backend.com/api';
```

To your actual backend URL:
```dart
// Development
static const String baseUrl = 'http://localhost:5000/api';

// Production
static const String baseUrl = 'https://api.yourdomain.com/api';
```

### ✅ Step 3: Uncomment API Methods
**File:** `lib/services/api_service.dart`

Find this section:
```dart
/* COMMENTED OUT: Uncomment when backend is ready
```

And uncomment ALL the code until the corresponding closing comment:
```dart
*/
```

Then comment out the dummy data methods:
```dart
// ==================== CURRENT IMPLEMENTATION (Using Dummy Data) ====================
// Comment out all methods in this section
```

### ✅ Step 4: Update Engineer Model
**File:** `lib/models/engineer_model.dart`

Find this line:
```dart
/* COMMENTED OUT: Uncomment when backend is ready
```

And uncomment the `fromJson()` and `toJson()` methods.

### ✅ Step 5: Update Engineer Screen
**File:** `lib/screens/engineer_screen.dart`

Make `EngineerHomeScreen` a StatefulWidget and add API calls:

```dart
class _EngineerHomeScreenState extends State<EngineerHomeScreen> {
  final ApiService _apiService = ApiService();
  List<Engineer> _engineers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEngineers();
  }

  Future<void> _loadEngineers() async {
    try {
      setState(() => _isLoading = true);
      final engineers = await _apiService.fetchEngineers();
      setState(() {
        _engineers = engineers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Then use _engineers instead of engineerDummyData in the UI
}
```

### ✅ Step 6: Update Search/Filter
**File:** `lib/screens/engineer_screen.dart`

Replace dummy filter logic with API calls:

```dart
// In filterEngineers() method
Future<void> filterEngineers() async {
  try {
    final filtered = await _apiService.filterEngineers(
      specialties: selectedSpecialties,
      location: selectedLocation,
      minRating: minRating,
    );
    setState(() {
      _filteredEngineers = filtered;
    });
  } catch (e) {
    // Show error
  }
}
```

### ✅ Step 7: Update Plan Upload
**File:** `lib/screens/engineer_screen.dart`

Update the upload plan section:

```dart
onPressed: () async {
  try {
    final success = await _apiService.uploadPlan(
      engineerId: item.id,
      planDescription: descriptionController.text,
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plan uploaded successfully!')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Upload failed: $e')),
    );
  }
}
```

### ✅ Step 8: Update Request Review
**File:** `lib/screens/engineer_screen.dart`

Update the request review button:

```dart
onPressed: () async {
  try {
    final response = await _apiService.requestReview(
      engineerId: item.id,
      clientMessage: clientMessageController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Review request sent: ${response['requestId']}')),
    );
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

### ✅ Step 9: Update Chat Messages
**File:** `lib/screens/engineer_screen.dart`

Update the chat functionality:

```dart
// In EngineerChatSheet
Future<void> sendMessage(String message) async {
  try {
    final success = await _apiService.sendMessage(
      engineerId: item.id,
      message: message,
    );
    if (success) {
      messageController.clear();
      // Refresh chat history
      _loadChatHistory();
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

Future<void> _loadChatHistory() async {
  try {
    final messages = await _apiService.getChatHistory(item.id);
    setState(() {
      _chatMessages = messages;
    });
  } catch (e) {
    // Handle error
  }
}
```

---

## 🧪 Testing Integration

### 1. Test with Postman First
Before testing in Flutter, make sure your backend endpoints work:

```
POST /api/engineers (Create test engineer)
GET /api/engineers (Retrieve engineers)
GET /api/engineers/:id (Get by ID)
```

### 2. Check Response Format
Make sure backend responses match this format:

```json
{
  "success": true,
  "data": [
    {
      "_id": "507f1f77bcf86cd799439011",
      "name": "Dr. Sarah Chan",
      "specialty": "Structural Engineer",
      "description": "Expert in...",
      "rating": 4.8,
      "location": "Colombo",
      "projects": 287,
      "reviews": 62,
      "imageUrl": "https://...",
      "experience": "15+ years",
      "hourlyRate": "LKR 2000/hr",
      "specializations": ["Soil Analysis", "Foundation Design"],
      "email": "sarah.chan@buildpro.com",
      "phoneNumber": "(+94) 77 591 2426"
    }
  ]
}
```

### 3. Handle Field Names
If your backend uses different field names, update the `fromJson()` method:

```dart
factory Engineer.fromJson(Map<String, dynamic> json) {
  return Engineer(
    id: json['_id'] ?? json['id'] ?? '',  // MongoDB uses _id
    name: json['name'] ?? 'Unknown',
    // ... adjust field names to match your backend
  );
}
```

---

## 🐛 Common Issues & Solutions

### Issue 1: "Connection Refused"
```
Error: Connection refused: 127.0.0.1:5000
```
**Solution:** 
- Make sure backend is running
- Check if backend URL is correct
- Check CORS configuration in backend

### Issue 2: "No Field 'data'"
```
NoSuchMethodError: The getter 'data' was called on null
```
**Solution:**
- Check backend response format matches expected JSON
- Update field names in `fromJson()` if different

### Issue 3: "CORS Error"
```
XMLHttpRequest error: Cross-Origin Request Blocked
```
**Solution:**
Add CORS headers in Node.js:
```javascript
const cors = require('cors');
app.use(cors({
  origin: ['http://localhost', 'https://yourdomain.com'],
  credentials: true
}));
```

### Issue 4: "Invalid JSON"
```
FormatException: Unexpected character
```
**Solution:**
- Test endpoint with Postman first
- Verify backend is sending valid JSON
- Check response has no extra characters before JSON

---

## 🔐 Add Authentication (Optional but Recommended)

### Step 1: Add JWT Token Storage
```dart
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
```

### Step 2: Add Token to API Requests
```dart
Future<List<Engineer>> fetchEngineers({int page = 1, int limit = 20}) async {
  try {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/engineers?page=$page&limit=$limit'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    // ... rest of code
  } catch (e) {
    throw Exception('Error fetching engineers: $e');
  }
}
```

---

## 📋 Final Checklist Before Going Live

- [ ] Backend is deployed and tested
- [ ] API baseUrl is updated to production
- [ ] All endpoints are uncommented
- [ ] Engineer model `fromJson` is uncommented
- [ ] Error handling is in place
- [ ] Loading states are shown in UI
- [ ] CORS is configured correctly
- [ ] Authentication tokens are stored
- [ ] Tested all features with real data
- [ ] App works offline with cached data (optional)
- [ ] Performance is acceptable
- [ ] No console errors or warnings

---

## 🚀 Deployment

When everything is working:

1. **Build APK** (Android):
```bash
flutter build apk --release
```

2. **Build IPA** (iOS):
```bash
flutter build ios --release
```

3. **Deploy Backend** to production server (AWS, Heroku, etc.)

4. **Update API URL** to production URL

5. **Test on production**

---

**You're ready to go live!** 🎉
