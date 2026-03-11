# Constructor Connect Backend API

Flask REST API backend for the Constructor Connect Flutter application. This backend provides endpoints for managing constructors, customer requests, and messaging.

## Project Structure

```
backend/
├── app.py              # Main Flask application
├── database.py         # Database initialization
├── models.py           # SQLAlchemy models
├── routes/
│   ├── constructors.py # Constructor endpoints
│   ├── requests.py     # Request endpoints
│   ├── chat.py         # Chat endpoints
├── requirements.txt    # Python dependencies
└── README.md          # This file
```

## Features

- ✅ RESTful API architecture
- ✅ SQLite database with SQLAlchemy ORM
- ✅ CORS enabled for Flutter frontend
- ✅ Constructor management and filtering
- ✅ Request management (customers to constructors)
- ✅ Real-time chat messaging
- ✅ Comprehensive error handling
- ✅ Sample seed data included

## Installation & Setup

### Prerequisites

- Python 3.8+
- pip (Python package installer)

### Step 1: Set Up Virtual Environment

```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate

# On Windows:
venv\Scripts\activate
```

### Step 2: Install Dependencies

```bash
pip install -r requirements.txt
```

### Step 3: Run the Server

```bash
python app.py
```

The server will start on `http://localhost:5000`

You should see:
```
======================================================
CONSTRUCTOR CONNECT API
======================================================

📍 Available Endpoints:
...
======================================================
Server starting on http://localhost:5000
======================================================
```

## Database

The application uses SQLite for data persistence. The database file (`constructor_connect.db`) is created automatically on first run.

### Models

1. **User**
   - Represents both customers and constructors
   - Fields: id, name, email, password_hash, role, created_at

2. **Constructor**
   - Represents construction professionals
   - Fields: id, name, specialty, description, rating, location, projects, reviews, image_url, email, phone, created_at

3. **Request**
   - Represents requests from customers to constructors
   - Fields: id, user_id, constructor_id, message, status, timestamp

4. **ChatMessage**
   - Represents messages between users
   - Fields: id, sender_id, receiver_id, message, timestamp

## API Endpoints

### Constructors

#### Get All Constructors
```
GET /api/constructors
```

Query Parameters:
- `search` - Search by name or description
- `specialty` - Filter by specialty
- `location` - Filter by location

Example:
```
GET /api/constructors?location=Colombo&specialty=Residential
```

Response:
```json
[
  {
    "id": 1,
    "name": "BuildPro Construction",
    "specialty": "Residential",
    "description": "...",
    "rating": 5.0,
    "location": "Kandy",
    "projects": 100,
    "reviews": 124,
    "image_url": "..."
  }
]
```

#### Get Constructor Details
```
GET /api/constructors/<id>
```

Response includes full details with email and phone.

#### Create Constructor
```
POST /api/constructors
Content-Type: application/json

{
  "name": "New Constructor",
  "specialty": "Residential",
  "description": "Description...",
  "location": "Colombo",
  "email": "email@example.com",
  "phone": "+94 701234567",
  "image_url": "https://...",
  "rating": 4.5,
  "projects": 50,
  "reviews": 45
}
```

#### Update Constructor
```
PUT /api/constructors/<id>
Content-Type: application/json

{
  "name": "Updated Name",
  "rating": 4.8
  // Only include fields to update
}
```

#### Delete Constructor
```
DELETE /api/constructors/<id>
```

### Requests

#### Create Request
```
POST /api/requests
Content-Type: application/json

{
  "user_id": 1,
  "constructor_id": 2,
  "message": "I need help with my residential project..."
}
```

Response:
```json
{
  "id": 1,
  "user_id": 1,
  "constructor_id": 2,
  "user_name": "Rajith Perera",
  "constructor_name": "BuildPro Construction",
  "message": "I need help...",
  "status": "pending",
  "timestamp": "2024-02-23T10:30:00"
}
```

#### Get User Requests
```
GET /api/requests/<user_id>
```

Query Parameters:
- `status` - Filter by status (pending, accepted, rejected)

#### Get Request Details
```
GET /api/requests/<request_id>
```

#### Update Request Status
```
PUT /api/requests/<request_id>
Content-Type: application/json

{
  "status": "accepted"  // or "rejected"
}
```

#### Delete Request
```
DELETE /api/requests/<request_id>
```

#### Get Constructor's Requests
```
GET /api/constructor/<constructor_id>/requests
```

### Chat

#### Send Message
```
POST /api/chat
Content-Type: application/json

{
  "sender_id": 1,
  "receiver_id": 2,
  "message": "Hello! I'm interested in your services."
}
```

Response:
```json
{
  "id": 1,
  "sender_id": 1,
  "receiver_id": 2,
  "sender_name": "Rajith Perera",
  "receiver_name": "BuildPro Construction",
  "message": "Hello!...",
  "timestamp": "2024-02-23T10:30:00"
}
```

#### Get Chat History
```
GET /api/chat?user1=<id>&user2=<id>&limit=50
```

Parameters:
- `user1` - First user ID (required)
- `user2` - Second user ID (required)
- `limit` - Number of messages (default: 50)

#### Get User Conversations
```
GET /api/chat/<user_id>/conversations
```

Returns list of unique users they've chatted with.

#### Delete Message
```
DELETE /api/chat/<message_id>
```

### Health Check
```
GET /api/health
```

## Testing with Postman

### 1. Import Collection

Create a new Postman collection and add the following requests:

#### 1. Get All Constructors
```
Method: GET
URL: http://localhost:5000/api/constructors
```

#### 2. Get Single Constructor
```
Method: GET
URL: http://localhost:5000/api/constructors/1
```

#### 3. Send Request
```
Method: POST
URL: http://localhost:5000/api/requests
Body (JSON):
{
  "user_id": 1,
  "constructor_id": 2,
  "message": "I need help with a residential project"
}
```

#### 4. Send Message
```
Method: POST
URL: http://localhost:5000/api/chat
Body (JSON):
{
  "sender_id": 1,
  "receiver_id": 2,
  "message": "Hello, are you available?"
}
```

#### 5. Get Chat History
```
Method: GET
URL: http://localhost:5000/api/chat?user1=1&user2=2
```

## Updating Flutter App

Update the API URL in [lib/service/api_service.dart](../../constructor_connect/lib/service/api_service.dart):

```dart
// For macOS development with localhost:
static const String baseUrl = "http://localhost:5000/api";

// For real devices (replace with your machine's IP):
static const String baseUrl = "http://192.168.1.100:5000/api";

// For Android emulator:
static const String baseUrl = "http://10.0.2.2:5000/api";
```

## Troubleshooting

### Port 5000 Already in Use
```bash
# Find process using port 5000
lsof -i :5000

# Kill the process
kill -9 <PID>
```

### CORS Errors
The backend has CORS enabled for all origins. If you still see CORS errors:
- Make sure backend is running on port 5000
- Check that Flutter app is calling correct URL

### Database Issues
```bash
# Delete the database and restart (will recreate with seed data)
rm constructor_connect.db
python app.py
```

## Future Enhancements

- [ ] User authentication with JWT
- [ ] Payment integration
- [ ] Rating and review system
- [ ] Image upload functionality
- [ ] Email notifications
- [ ] Admin dashboard
- [ ] Advanced search and filtering
- [ ] User verification system

## License

This project is part of the ArchiSri platform.
