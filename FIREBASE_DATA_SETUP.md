# Firebase Data Setup for Engineer & Constructor Connect

## Overview
Both Engineer Connect and Constructor Connect features fetch data from Firebase Firestore and display contact details including phone numbers for WhatsApp integration.

---

## ENGINEERS Collection Setup

**Collection Name:** `engineers`

### Required Document Fields:

```json
{
  "fullName": "John Smith",
  "email": "john@example.com",
  "phoneNumber": "+94701234567",
  "specialization": "Civil Engineer",
  "location": "Colombo",
  "description": "Expert in structural design with 10+ years experience",
  "imageUrl": "https://example.com/photo.jpg",
  "yearsOfExperience": "10",
  "registrationNumber": "PE/2012/1234",
  "isVerified": true,
  "rating": 4.8,
  "projects": 25,
  "ratePerHour": "5000"
}
```

### Field Name Alternatives (Phone Number):
The system checks for phone in this order:
- `phoneNumber` ✅ (RECOMMENDED)
- `phone`
- `mobile`
- `contactNumber`
- `whatsapp`

**Use one of these field names to store the phone number.**

### Field Name Alternatives (Other Fields):

| Data | Preferred | Alternative 1 | Alternative 2 |
|------|-----------|--------------|--------------|
| Name | `fullName` | `name` | - |
| Specialty | `specialization` | `specialty` | - |
| Description | `description` | `bio` | `about` |
| Company | `company` | `organization` | - |
| Email | `email` | - | - |
| Location | `location` | `district` | `address` |
| Image | `imageUrl` | `image_url` | `photoUrl` |

---

## CONSTRUCTORS Collection Setup

**Primary Collection Name:** `companies` (recommended)
**Fallback Collection Name:** `constructors`

### Required Document Fields:

```json
{
  "companyName": "BuildRight Construction",
  "email": "info@buildright.com",
  "phone": "+94701234567",
  "constructionType": "Residential Construction",
  "location": "Galle",
  "description": "Professional construction company specializing in residential and commercial projects",
  "imageUrl": "https://example.com/company-logo.jpg",
  "rating": 4.6,
  "projects": 45,
  "projectTypes": ["Residential", "Commercial", "Industrial"],
  "isVerified": true
}
```

### Field Name Alternatives (Phone Number):
The system checks for phone in this order:
- `phone` ✅ (RECOMMENDED)
- `phoneNumber`
- `mobile`
- `contactNumber`
- `whatsapp`

**Use one of these field names to store the phone number.**

### Field Name Alternatives (Other Fields):

| Data | Preferred | Alternative 1 | Alternative 2 |
|------|-----------|--------------|--------------|
| Name | `companyName` | `name` | `displayName` |
| Type | `constructionType` | `specialty` | `specialization` |
| Description | `description` | `bio` | `about` |
| Email | `email` | - | - |
| Location | `location` | `district` | `address` |
| Image | `imageUrl` | `image_url` | `photoUrl` |

---

## WhatsApp Integration Flow

### What Happens When User Clicks "Connect via WhatsApp":

```
1. User clicks Engineer/Constructor card → Detail sheet opens
2. System extracts phone number using helper function
3. If phone exists:
   - WhatsApp button is ENABLED (green)
   - Phone displayed in Contact Information
4. If phone is empty/not provided:
   - WhatsApp button is DISABLED (grey)
   - Shows "Phone number not available" message
5. On button click:
   - Opens WhatsApp chat with pre-filled message
   - Message includes engineer/contractor name
   - Opening message provided for context
```

---

## Testing Checklist

- [ ] **Create test engineers** in `engineers` collection with phone numbers
- [ ] **Create test constructors** in `companies` collection with phone numbers
- [ ] **Verify phone fields** use one of the supported names
- [ ] **Test Engineer Connect:**
  - [ ] Search and filter engineers
  - [ ] Click engineer card
  - [ ] Check phone number displays in Contact Information
  - [ ] Verify WhatsApp button is enabled (green)
  - [ ] Click WhatsApp button and verify chat opens
- [ ] **Test Constructor Connect:**
  - [ ] Search and filter constructors
  - [ ] Click constructor card
  - [ ] Check phone number displays in Contact Information
  - [ ] Verify WhatsApp button is enabled (green)
  - [ ] Click WhatsApp button and verify chat opens
- [ ] **Test without phone:**
  - [ ] Create engineer/constructor WITHOUT phone number
  - [ ] Verify WhatsApp button shows as disabled (grey)
  - [ ] Verify "Phone number not available" message shown

---

## Firebase Firestore Rules (Recommended)

For production, set these security rules to allow reading all engineers/constructors:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow anyone to read engineers and constructors
    match /engineers/{document=**} {
      allow read: if true;
      allow create, update, delete: if request.auth != null;
    }
    
    match /companies/{document=**} {
      allow read: if true;
      allow create, update, delete: if request.auth != null;
    }
    
    match /constructors/{document=**} {
      allow read: if true;
      allow create, update, delete: if request.auth != null;
    }
  }
}
```

---

## Phone Number Format

Recommended format for WhatsApp:
- **International Format:** +[country code][number]
- **Example:** +94701234567 (Sri Lanka)
- **NO spaces, NO dashes, NO parentheses**

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Phone numbers not showing | Verify field name: use `phoneNumber` for engineers, `phone` for constructors |
| WhatsApp button cannot open | Ensure WhatsApp is installed on device; check phone number format |
| No engineers/constructors showing | Check Firestore read permissions in security rules |
| Blank fields displayed | Ensure required fields are populated with non-empty values |
| Contact information says "Not provided" | Fill in the field with actual data |

---

## Code Reference

### Engineer Helper Function
```dart
String _engineerPhone(Map<String, dynamic> data) => _firstNonEmpty(data, [
  'phoneNumber',    // Check 1st
  'phone',          // Check 2nd
  'mobile',         // Check 3rd
  'contactNumber',  // Check 4th
  'whatsapp',       // Check 5th
]);
```

### Constructor Helper Function
```dart
String _constructorPhone(Map<String, dynamic> data) =>
    _constructorFirstNonEmpty(data, [
      'phone',           // Check 1st
      'phoneNumber',     // Check 2nd
      'mobile',          // Check 3rd
      'contactNumber',   // Check 4th
      'whatsapp',        // Check 5th
    ]);
```

---

## Summary

✅ Both **Engineer Connect** and **Constructor Connect** are fully implemented  
✅ Phone numbers automatically fetched from Firebase using flexible field names  
✅ WhatsApp button enabled only when phone number exists  
✅ Contact information displayed with phone for direct calling  
✅ Consistent UI/UX across both features
