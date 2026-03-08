# Engineer Connect - Backend Setup Guide (Node.js)

## 🎯 Backend Overview
This guide outlines the structure and API endpoints needed for the EngineerConnect Flutter app's Node.js backend.

---

## 📦 Tech Stack Recommended

```json
{
  "runtime": "Node.js 18+",
  "framework": "Express.js",
  "database": "MongoDB",
  "authentication": "JWT",
  "file_storage": "AWS S3 or Local Storage",
  "real-time": "Socket.io (for chat)"
}
```

---

## 📂 Backend Project Structure Recommended

```
engineer-connect-backend/
├── src/
│   ├── config/
│   │   ├── database.js          // MongoDB connection
│   │   ├── environment.js       // ENV variables
│   │   └── constants.js         // App constants
│   │
│   ├── models/
│   │   ├── Engineer.js          // Engineer schema
│   │   ├── Plan.js              // Plan schema
│   │   ├── Request.js           // Request schema
│   │   ├── Message.js           // Message schema
│   │   └── User.js              // User/Client schema
│   │
│   ├── routes/
│   │   ├── engineers.js         // Engineer endpoints
│   │   ├── plans.js             // Plan endpoints
│   │   ├── requests.js          // Request endpoints
│   │   ├── chats.js             // Chat endpoints
│   │   └── auth.js              // Authentication endpoints
│   │
│   ├── controllers/
│   │   ├── engineerController.js
│   │   ├── planController.js
│   │   ├── requestController.js
│   │   └── chatController.js
│   │
│   ├── middleware/
│   │   ├── auth.js              // JWT verification
│   │   ├── errorHandler.js      // Global error handling
│   │   └── validation.js        // Input validation
│   │
│   ├── utils/
│   │   ├── responseFormatter.js // Standard response format
│   │   └── fileUpload.js        // File upload handling
│   │
│   └── app.js                   // Express app setup
│
├── server.js                    // Entry point
├── package.json
├── .env                         // Environment variables
├── .env.example
└── README.md
```

---

## 🗄️ MongoDB Schemas

### 1. Engineer Schema
```javascript
// models/Engineer.js
const engineerSchema = new Schema({
  // Personal Info
  name: {
    type: String,
    required: true,
    trim: true
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true
  },
  phoneNumber: {
    type: String,
    required: true
  },
  profileImage: {
    type: String,
    default: 'https://via.placeholder.com/150'
  },

  // Professional Info
  specialty: {
    type: String,
    required: true,
    enum: ['Civil', 'Structural', 'MEP', 'Architectural', 'Environmental']
  },
  specializations: [String],     // Tags like ["Soil Analysis", "Foundation Design"]
  description: {
    type: String,
    required: true
  },
  experience: {
    type: String,
    default: 'Not specified'
  },
  hourlyRate: {
    type: String,
    default: 'Not specified'
  },

  // Metrics
  rating: {
    type: Number,
    min: 0,
    max: 5,
    default: 4.0
  },
  totalReviews: {
    type: Number,
    default: 0
  },
  completedProjects: {
    type: Number,
    default: 0
  },

  // Location
  location: {
    type: String,
    required: true
  },
  city: String,
  country: String,

  // Status
  isVerified: {
    type: Boolean,
    default: false
  },
  isAvailable: {
    type: Boolean,
    default: true
  },

  // Timestamps
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });
```

### 2. Plan Schema
```javascript
// models/Plan.js
const planSchema = new Schema({
  engineerId: {
    type: Schema.Types.ObjectId,
    ref: 'Engineer',
    required: true
  },
  description: String,
  planFile: {
    type: String,
    required: true  // URL or file path
  },
  fileType: {
    type: String,
    enum: ['PDF', 'DWG', 'IMAGE'],
    default: 'PDF'
  },
  uploadedAt: {
    type: Date,
    default: Date.now
  }
});
```

### 3. Request Schema
```javascript
// models/Request.js
const requestSchema = new Schema({
  engineerId: {
    type: Schema.Types.ObjectId,
    ref: 'Engineer',
    required: true
  },
  clientId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  planDescription: String,
  clientMessage: String,
  status: {
    type: String,
    enum: ['pending', 'accepted', 'rejected', 'completed'],
    default: 'pending'
  },
  requestedAt: {
    type: Date,
    default: Date.now
  },
  respondedAt: Date,
  completedAt: Date
}, { timestamps: true });
```

### 4. Message Schema
```javascript
// models/Message.js
const messageSchema = new Schema({
  engineerId: {
    type: Schema.Types.ObjectId,
    ref: 'Engineer',
    required: true
  },
  clientId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  senderId: {
    type: Schema.Types.ObjectId,
    required: true
  },
  senderType: {
    type: String,
    enum: ['engineer', 'client'],
    required: true
  },
  message: {
    type: String,
    required: true
  },
  sentAt: {
    type: Date,
    default: Date.now
  },
  read: {
    type: Boolean,
    default: false
  }
});
```

---

## 🔌 API Endpoints Breakdown

### 1. Engineers API Routes

#### Get All Engineers (with Pagination)
```
GET /api/engineers
Query: ?page=1&limit=20&sortBy=rating

Response:
{
  success: true,
  data: [ { Engineer objects } ],
  pagination: {
    page: 1,
    limit: 20,
    total: 150,
    pages: 8
  }
}
```

#### Get Engineer by ID
```
GET /api/engineers/:id

Response:
{
  success: true,
  data: { Engineer object }
}
```

#### Search Engineers
```
GET /api/engineers/search?query=sarah&specialty=Civil&location=Colombo&minRating=4.0

Response:
{
  success: true,
  data: [ { Matching engineer objects } ],
  count: 5
}
```

#### Filter Engineers
```
GET /api/engineers/filter

Query Parameters:
- specialty: String
- location: String
- minRating: Number
- isVerified: Boolean
- page: Number
- limit: Number

Response:
{
  success: true,
  data: [ { Engineer objects } ],
  pagination: { ... }
}
```

#### Create Engineer (Admin)
```
POST /api/engineers
Headers: Authorization: Bearer token

Body:
{
  name: String (required),
  email: String (required),
  phoneNumber: String (required),
  specialty: String (required),
  description: String,
  location: String,
  hourlyRate: String,
  profileImage: String
}

Response:
{
  success: true,
  data: { Created engineer object }
}
```

#### Update Engineer
```
PUT /api/engineers/:id
Headers: Authorization: Bearer token

Body: { Updated fields }

Response:
{
  success: true,
  data: { Updated engineer object }
}
```

#### Delete Engineer (Admin)
```
DELETE /api/engineers/:id
Headers: Authorization: Bearer token

Response:
{
  success: true,
  message: "Engineer deleted successfully"
}
```

---

### 2. Plans API Routes

#### Upload Plan
```
POST /api/plans/upload
Headers: 
  - Authorization: Bearer token
  - Content-Type: multipart/form-data

Body (Form Data):
- engineerId: String (required)
- description: String
- planFile: File (required, PDF/DWG/IMAGE)

Response:
{
  success: true,
  data: {
    planId: ObjectId,
    engineerId: ObjectId,
    fileUrl: String,
    uploadedAt: Timestamp
  }
}
```

#### Get Engineer's Plans
```
GET /api/plans/engineer/:engineerId

Response:
{
  success: true,
  data: [ { Plan objects } ]
}
```

#### Get Plan by ID
```
GET /api/plans/:planId

Response:
{
  success: true,
  data: { Plan object }
}
```

#### Delete Plan
```
DELETE /api/plans/:planId
Headers: Authorization: Bearer token

Response:
{
  success: true,
  message: "Plan deleted successfully"
}
```

---

### 3. Requests API Routes

#### Create Review Request
```
POST /api/requests/create
Headers: Authorization: Bearer token

Body:
{
  engineerId: ObjectId (required),
  clientId: ObjectId (required),
  planDescription: String,
  clientMessage: String,
  planFile: String (optional, URL)
}

Response:
{
  success: true,
  data: {
    requestId: ObjectId,
    status: "pending",
    createdAt: Timestamp
  }
}
```

#### Get Request Details
```
GET /api/requests/:requestId
Headers: Authorization: Bearer token

Response:
{
  success: true,
  data: { Request object with engineer details }
}
```

#### Update Request Status
```
PUT /api/requests/:requestId
Headers: Authorization: Bearer token

Body:
{
  status: "accepted" | "rejected" | "completed"
}

Response:
{
  success: true,
  data: { Updated request object }
}
```

#### Get Requests for Engineer
```
GET /api/requests/engineer/:engineerId
Query: ?status=pending&page=1&limit=10

Response:
{
  success: true,
  data: [ { Request objects } ],
  pagination: { ... }
}
```

#### Get Requests for Client
```
GET /api/requests/client/:clientId
Query: ?status=&page=1&limit=10

Response:
{
  success: true,
  data: [ { Request objects } ],
  pagination: { ... }
}
```

---

### 4. Chat API Routes

#### Get Chat History
```
GET /api/chats/:engineerId/history?clientId=xyz
Headers: Authorization: Bearer token

Query: ?page=1&limit=50

Response:
{
  success: true,
  data: [ { Message objects } ],
  pagination: { ... }
}
```

#### Send Message
```
POST /api/chats/send
Headers: Authorization: Bearer token

Body:
{
  engineerId: ObjectId (required),
  clientId: ObjectId (required),
  senderId: ObjectId (required),
  senderType: "engineer" | "client",
  message: String (required)
}

Response:
{
  success: true,
  data: { Message object with timestamp }
}
```

#### Mark Messages as Read
```
PUT /api/chats/mark-read
Headers: Authorization: Bearer token

Body:
{
  engineerId: ObjectId,
  clientId: ObjectId,
  messageIds: [ ObjectId ]
}

Response:
{
  success: true,
  message: "Messages marked as read"
}
```

---

## 🔐 Authentication (JWT)

### Login Endpoint
```
POST /api/auth/login

Body:
{
  email: String (required),
  password: String (required)
}

Response:
{
  success: true,
  data: {
    token: "jwt_token_here",
    engineer: { Engineer object }
  }
}
```

### Refresh Token
```
POST /api/auth/refresh
Headers: Authorization: Bearer refresh_token

Response:
{
  success: true,
  data: {
    token: "new_jwt_token"
  }
}
```

---

## 📋 Standard Response Format

All endpoints should return in this format:

```javascript
// Success Response
{
  success: true,
  data: { ... },
  message: "Optional message"
}

// Error Response
{
  success: false,
  error: "Error message",
  details: { ... } // optional
}
```

---

## 🚀 Getting Started Backend Development

### Step 1: Initialize Project
```bash
mkdir engineer-connect-backend
cd engineer-connect-backend
npm init -y
```

### Step 2: Install Dependencies
```bash
npm install express mongoose dotenv cors multer aws-sdk bcryptjs jsonwebtoken
npm install --save-dev nodemon
```

### Step 3: Create .env File
```
NODE_ENV=development
PORT=5000
MONGODB_URI=mongodb://localhost:27017/engineer-connect
JWT_SECRET=your-secret-key-here
JWT_EXPIRE=7d
CORS_ORIGIN=http://localhost:3000,*
```

### Step 4: Update package.json
```json
"scripts": {
  "start": "node server.js",
  "dev": "nodemon server.js",
  "test": "jest"
}
```

### Step 5: Create Express Server
```javascript
// server.js
require('dotenv').config();
const app = require('./src/app');

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

---

## ✅ Backend Checklist

- [ ] Create Express app structure
- [ ] Set up MongoDB connection
- [ ] Create all schemas/models
- [ ] Implement Engineers API (GET, POST, PUT, DELETE)
- [ ] Implement search and filter
- [ ] Implement Plans API
- [ ] Implement Requests API
- [ ] Implement Chat API
- [ ] Implement Authentication (JWT)
- [ ] Add input validation
- [ ] Add error handling
- [ ] Add CORS configuration
- [ ] Test all endpoints with Postman
- [ ] Deploy to server (AWS/Heroku/DigitalOcean)
- [ ] Update Flutter baseUrl with production URL

---

## 🔗 Connection Flow

```
Flutter App
    ↓
API Service (api_service.dart)
    ↓
Node.js Backend (Express)
    ↓
MongoDB Database
    ↓
[Response back through the chain]
```

---

## 📞 Testing Backend Endpoints

Use Postman to test:

1. First, get a JWT token from `/api/auth/login`
2. Add token to Authorization header:
   ```
   Authorization: Bearer <your_jwt_token>
   ```
3. Test each endpoint with sample data
4. Verify response matches the format in Flutter code

---

**Backend is ready to be built! Start with MongoDB setup and Express server.** 🚀
