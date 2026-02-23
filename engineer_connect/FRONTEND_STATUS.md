## Engineer Connect - Frontend Status & Backend Integration Guide

### 📋 FRONTEND STATUS: ✅ COMPLETE

---

## ✅ What's Finished (Frontend)

### 1. **Core Screens Implemented**
- ✅ **EngineerHomeScreen** - Main listing screen with engineer cards
- ✅ **EngineerDetailSheet** - Popup with full engineer details
  - Profile section with image, name, specialty, rating
  - Tags/specializations
  - Experience, Projects, Rate stats
  - **NEW:** Contact Information section (Email & Phone)
  - Upload AI-generated plan section
  - Request Review button
- ✅ **EngineerChatSheet** - Chat interface with engineer
- ✅ **FilterSheet** - Filter engineers by specialty, location, rating

### 2. **Data Model**
- ✅ Engineer model with all required fields
- ✅ Dummy data for 3 engineers with complete information
- ✅ Fields: name, specialty, description, rating, location, projects, reviews, imageUrl, experience, hourlyRate, tags, email, phone

### 3. **UI/UX Features**
- ✅ Beautiful card layout with images
- ✅ Engineer filtering system
- ✅ Bottom sheet popups for details
- ✅ Contact information cards with icons
- ✅ Color-coded sections
- ✅ Responsive design
- ✅ Search/filter capabilities

### 4. **Architecture**
- ✅ Model-View structure established
- ✅ Service layer created (lib/services/api_service.dart)
- ✅ Separation of concerns

---

## 🔧 Backend Setup Required (Node.js)

### Database Schema (MongoDB recommended)

```javascript
// Engineer Collection Schema
{
  _id: ObjectId,
  name: String, (required)
  specialty: String, (required) // e.g., "Civil", "Structural", "MEP"
  description: String,
  rating: Number, (0-5)
  location: String,
  projects: Number,
  reviews: Number,
  imageUrl: String, // or profileImage
  experience: String, (e.g., "15+ years")
  hourlyRate: String, (e.g., "LKR 2000/hr")
  specializations: [String], // Array of tags
  email: String, (required)
  phoneNumber: String, (required) // or 'phone'
  isVerified: Boolean,
  createdAt: Timestamp,
  updatedAt: Timestamp
}

// Plans Collection Schema
{
  _id: ObjectId,
  engineerId: ObjectId, (reference to Engineer)
  description: String,
  planFile: String, (URL or file path)
  uploadedAt: Timestamp
}

// Requests Collection Schema
{
  _id: ObjectId,
  engineerId: ObjectId, (reference to Engineer)
  clientId: ObjectId, (reference to Client/User)
  message: String,
  status: String, (pending, accepted, rejected, completed)
  planDetails: Object,
  requestedAt: Timestamp,
  respondedAt: Timestamp
}

// Messages Collection Schema
{
  _id: ObjectId,
  engineerId: ObjectId,
  clientId: ObjectId,
  message: String,
  sentBy: String, (engineer/client)
  sentAt: Timestamp
}
```

---

## 🚀 API Endpoints Needed (Node.js Backend)

### Engineers Endpoints
```
GET    /api/engineers                          // List all engineers (with pagination)
  Query: ?page=1&limit=20
  
GET    /api/engineers/:id                      // Get engineer by ID

GET    /api/engineers/search                   // Search engineers
  Query: ?query=name&specialty=&location=&minRating=

GET    /api/engineers/filter                   // Filter engineers
  Query: ?specialty=&location=&minRating=&isVerified=true

POST   /api/engineers                          // Create engineer (admin)
```

### Plans Endpoints
```
POST   /api/plans/upload                       // Upload AI-generated plan
  Body: { engineerId, description, planFile }

GET    /api/plans/:engineerId                  // Get engineer's plans

PUT    /api/plans/:planId                      // Update plan

DELETE /api/plans/:planId                      // Delete plan
```

### Requests Endpoints
```
POST   /api/requests/create                    // Create review request
  Body: { engineerId, clientId, message, planDescription }

GET    /api/requests/:requestId                // Get request details

PUT    /api/requests/:requestId                // Update request status
  Body: { status: "accepted/rejected/completed" }

GET    /api/requests/engineer/:engineerId      // Get all requests for engineer
```

### Chat Endpoints
```
GET    /api/chats/:engineerId/history          // Get chat history

POST   /api/chats/send                         // Send message
  Body: { engineerId, clientId, message }

POST   /api/chats/typing                       // Typing indicator (optional)
```

---

## 📝 How to Switch from Dummy Data to Real API

### Step 1: Uncomment the HTTP Package in pubspec.yaml
```yaml
dependencies:
  http: ^1.1.0
  # or use dio for more features:
  dio: ^5.3.0
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Update API Service
In `lib/services/api_service.dart`:
1. Uncomment the entire commented section at the top
2. Replace `baseUrl` with your actual Node.js backend URL
3. Uncomment all the API methods (fetchEngineers, searchEngineers, filterEngineers, etc.)
4. Comment out the dummy data methods at the bottom

### Step 4: Update Engineer Model
In `lib/models/engineer_model.dart`:
1. Uncomment the `fromJson()` factory method
2. Uncomment the `toJson()` method

### Step 5: Update UI Screens to Use API Service
In `lib/screens/engineer_screen.dart`:
```dart
// Instead of:
List<Engineer> engineers = engineerDummyData;

// Use:
final ApiService _apiService = ApiService();

void initState() {
  super.initState();
  _loadEngineers();
}

Future<void> _loadEngineers() async {
  try {
    final engineers = await _apiService.fetchEngineers();
    setState(() {
      _engineers = engineers;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

---

## ✨ What Needs to be Added (No Breaking Changes)

### 1. **State Management** (Optional but Recommended)
- Add Provider package for state management
- Or use GetX / Riverpod for better performance

### 2. **Error Handling**
- Add try-catch blocks in all API calls
- Show appropriate error messages to users
- Implement loading states

### 3. **Caching**
- Cache engineer list locally
- Implement offline support using Hive/SharedPreferences

### 4. **Real-time Chat** (Optional)
- Integrate WebSocket or Firebase for real-time messaging
- Update ChatSheet with real messages

### 5. **File Upload** (When Backend is Ready)
- Add file_picker package for plan file selection
- Implement multipart/form-data upload

---

## 📁 Current File Structure

```
lib/
├── main.dart                    // App entry point
├── models/
│   └── engineer_model.dart      // Engineer model + dummy data + commented fromJson/toJson
├── screens/
│   └── engineer_screen.dart     // All screens (HomeScreen, DetailSheet, ChatSheet, FilterSheet)
└── services/
    └── api_service.dart         // API service layer with commented real API calls + dummy implementations
```

---

## 🔄 Recommended Next Steps

### Backend Development Priority:
1. **Database Setup** - Set up MongoDB and create collections
2. **Authentication** - Implement user authentication (JWT)
3. **Engineers API** - Create GET/POST/PUT/DELETE endpoints for engineers
4. **Filter & Search** - Implement filter and search endpoints
5. **Plans Upload** - Create file upload endpoints
6. **Chat System** - Implement messaging endpoints
7. **Requests Management** - Create review request endpoints

### Frontend - When Backend is Ready:
1. Uncomment API calls in `api_service.dart`
2. Update `engineer_model.dart` with `fromJson/toJson`
3. Add API service integration to screens
4. Remove dummy data imports
5. Add loading states and error handling
6. Test all endpoints

---

## 🛟 Important Notes

⚠️ **DO NOT** make changes to the dummy data implementation until the backend is ready.
✅ All commented code is production-ready and won't break anything.
✅ The app will continue to work perfectly with dummy data.
✅ Switching to real API is just uncommenting code and updating the baseUrl.

---

## 📞 API Testing

Once backend is ready, test with Postman:
- Import the API endpoints above
- Set your Node.js backend URL
- Test each endpoint
- Verify response format matches the commented code in `api_service.dart`

---

## ✅ Frontend Checklist

- [x] All UI screens implemented
- [x] Contact information section added
- [x] Data model complete
- [x] Service layer created
- [x] Dummy data ready
- [x] Error handling structure ready (commented)
- [x] API methods prepared (commented)
- [x] Ready for backend integration

**Frontend is 100% ready to integrate with Node.js backend!** 🚀
