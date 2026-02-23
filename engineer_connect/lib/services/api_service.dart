// API Service Layer for Engineer Connect
// This service layer handles all API calls to the Python Flask backend

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/engineer_model.dart';

class ApiService {
  // Backend API configuration
  // For iOS Simulator: use localhost with port 8000
  // For Android Emulator: use 10.0.2.2:8000
  // For real devices: use your machine's IP address (e.g., http://192.168.1.100:8000/api)
  static const String baseUrl = 'http://10.31.27.46:8000/api';

  // Fetch all engineers with pagination
  Future<List<Engineer>> fetchEngineers({int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/engineers'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((engineer) => Engineer.fromJson(engineer)).toList();
      } else {
        throw Exception('Failed to load engineers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching engineers: $e');
    }
  }

  // Get engineer details by ID
  Future<Engineer> getEngineerById(String engineerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/engineers/$engineerId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return Engineer.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load engineer details');
      }
    } catch (e) {
      throw Exception('Error fetching engineer: $e');
    }
  }

  // Search engineers by specialty/location/name
  Future<List<Engineer>> searchEngineers({
    required String query,
    String? specialty,
    String? location,
    double? minRating,
  }) async {
    try {
      String queryString = '?search=$query';
      if (specialty != null) queryString += '&specialty=$specialty';
      if (location != null) queryString += '&location=$location';

      final response = await http.get(
        Uri.parse('$baseUrl/engineers$queryString'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((engineer) => Engineer.fromJson(engineer)).toList();
      } else {
        throw Exception('Failed to search engineers');
      }
    } catch (e) {
      throw Exception('Error searching engineers: $e');
    }
  }

  // Create a new engineer (admin only)
  Future<Engineer> createEngineer({
    required String name,
    required String specialty,
    required String description,
    required String location,
    required String email,
    required String phone,
    String? imageUrl,
    String? experience,
    String? hourlyRate,
    List<String>? tags,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/engineers'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'specialty': specialty,
          'description': description,
          'location': location,
          'email': email,
          'phone': phone,
          'image_url': imageUrl,
          'experience': experience,
          'hourly_rate': hourlyRate,
          'tags': tags ?? [],
        }),
      );

      if (response.statusCode == 201) {
        return Engineer.fromJson(jsonDecode(response.body)['engineer']);
      } else {
        throw Exception('Failed to create engineer');
      }
    } catch (e) {
      throw Exception('Error creating engineer: $e');
    }
  }

  // Update engineer details
  Future<Engineer> updateEngineer({
    required String engineerId,
    String? name,
    String? specialty,
    String? description,
    String? location,
    String? email,
    String? phone,
    double? rating,
    String? imageUrl,
    String? experience,
    String? hourlyRate,
    List<String>? tags,
  }) async {
    try {
      final Map<String, dynamic> updateData = {};
      if (name != null) updateData['name'] = name;
      if (specialty != null) updateData['specialty'] = specialty;
      if (description != null) updateData['description'] = description;
      if (location != null) updateData['location'] = location;
      if (email != null) updateData['email'] = email;
      if (phone != null) updateData['phone'] = phone;
      if (rating != null) updateData['rating'] = rating;
      if (imageUrl != null) updateData['image_url'] = imageUrl;
      if (experience != null) updateData['experience'] = experience;
      if (hourlyRate != null) updateData['hourly_rate'] = hourlyRate;
      if (tags != null) updateData['tags'] = tags;

      final response = await http.put(
        Uri.parse('$baseUrl/engineers/$engineerId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        return Engineer.fromJson(jsonDecode(response.body)['engineer']);
      } else {
        throw Exception('Failed to update engineer');
      }
    } catch (e) {
      throw Exception('Error updating engineer: $e');
    }
  }

  // Delete an engineer
  Future<bool> deleteEngineer(String engineerId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/engineers/$engineerId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete engineer');
      }
    } catch (e) {
      throw Exception('Error deleting engineer: $e');
    }
  }
}
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/plans/upload'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'engineerId': engineerId,
          'description': planDescription,
          'uploadedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to upload plan');
      }
    } catch (e) {
      throw Exception('Error uploading plan: $e');
    }
  }

  // Request review/booking
  Future<Map<String, dynamic>> requestReview({
    required String engineerId,
    required String clientMessage,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/requests/create'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'engineerId': engineerId,
          'message': clientMessage,
          'requestedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to create request');
      }
    } catch (e) {
      throw Exception('Error creating request: $e');
    }
  }

  // Filter engineers
  Future<List<Engineer>> filterEngineers({
    bool? isVerified,
    List<String>? specialties,
    String? location,
    double? minRating,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      String queryString = '?page=$page&limit=$limit';
      if (isVerified != null) queryString += '&isVerified=$isVerified';
      if (location != null) queryString += '&location=$location';
      if (minRating != null) queryString += '&minRating=$minRating';
      if (specialties != null && specialties.isNotEmpty) {
        queryString += '&specialties=${specialties.join(',')}';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/engineers/filter$queryString'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['data'];
        return jsonData.map((engineer) => Engineer.fromJson(engineer)).toList();
      } else {
        throw Exception('Failed to filter engineers');
      }
    } catch (e) {
      throw Exception('Error filtering engineers: $e');
    }
  }

  // Get chat history
  Future<List<Map<String, dynamic>>> getChatHistory(String engineerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chats/$engineerId/history'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['data'];
        return List<Map<String, dynamic>>.from(jsonData);
      } else {
        throw Exception('Failed to load chat history');
      }
    } catch (e) {
      throw Exception('Error loading chat history: $e');
    }
  }

  // Send message
  Future<bool> sendMessage({
    required String engineerId,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chats/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'engineerId': engineerId,
          'message': message,
          'sentAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }
  
  */

  // ==================== CURRENT IMPLEMENTATION (Using Dummy Data) ====================
  
  // This will be replaced with actual API calls
  Future<List<Engineer>> fetchEngineers({int page = 1, int limit = 20}) async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return engineerDummyData;
  }

  Future<Engineer> getEngineerById(String engineerId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: Match by ID when backend is ready
    return engineerDummyData.isNotEmpty ? engineerDummyData[0] : engineerDummyData[0];
  }

  Future<List<Engineer>> searchEngineers({
    required String query,
    String? specialty,
    String? location,
    double? minRating,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return engineerDummyData.where((engineer) {
      bool matchesQuery = engineer.name.toLowerCase().contains(query.toLowerCase()) ||
          engineer.specialty.toLowerCase().contains(query.toLowerCase());
      bool matchesSpecialty = specialty == null || engineer.specialty.contains(specialty);
      bool matchesLocation = location == null || engineer.location == location;
      bool matchesRating = minRating == null || engineer.rating >= minRating;

      return matchesQuery && matchesSpecialty && matchesLocation && matchesRating;
    }).toList();
  }

  Future<List<Engineer>> filterEngineers({
    bool? isVerified,
    List<String>? specialties,
    String? location,
    double? minRating,
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return engineerDummyData.where((engineer) {
      bool matchesSpecialty = specialties == null || specialties.isEmpty || specialties.contains(engineer.specialty);
      bool matchesLocation = location == null || engineer.location == location;
      bool matchesRating = minRating == null || engineer.rating >= minRating;

      return matchesSpecialty && matchesLocation && matchesRating;
    }).toList();
  }

  Future<bool> uploadPlan({
    required String engineerId,
    required String planDescription,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  Future<Map<String, dynamic>> requestReview({
    required String engineerId,
    required String clientMessage,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'requestId': 'REQ_${DateTime.now().millisecondsSinceEpoch}',
      'status': 'pending',
      'message': 'Request received successfully',
    };
  }

  Future<List<Map<String, dynamic>>> getChatHistory(String engineerId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  Future<bool> sendMessage({
    required String engineerId,
    required String message,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
