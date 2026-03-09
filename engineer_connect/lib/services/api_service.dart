import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/engineer_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.31.27.46:8000/api';

  Future<List<Engineer>> fetchEngineers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/engineers'),
        headers: {'Content-Type': 'application/json'},
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

  Future<Engineer> getEngineerById(String engineerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/engineers/$engineerId'),
        headers: {'Content-Type': 'application/json'},
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

  Future<List<Engineer>> searchEngineers({
    required String query,
    String? specialty,
    String? location,
  }) async {
    try {
      String queryString = '?search=$query';
      if (specialty != null) queryString += '&specialty=$specialty';
      if (location != null) queryString += '&location=$location';

      final response = await http.get(
        Uri.parse('$baseUrl/engineers$queryString'),
        headers: {'Content-Type': 'application/json'},
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
        headers: {'Content-Type': 'application/json'},
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
        headers: {'Content-Type': 'application/json'},
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

  Future<bool> deleteEngineer(String engineerId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/engineers/$engineerId'),
        headers: {'Content-Type': 'application/json'},
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
