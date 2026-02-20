import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/constructor_model.dart';

class ApiService {
  //  IP address/URL  of API backend
  static const String baseUrl = "http://10.0.2.2:5000/api";

  Future<List<Constructor>> fetchConstructors({String? location}) async {
    try {
      final uri = location != null 
        ? Uri.parse('$baseUrl/constructors?location=$location')
        : Uri.parse('$baseUrl/constructors');
        
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Constructor.fromJson(item)).toList();
      } else {
        throw "Server Error";
      }
    } catch (e) {
      throw "Connection Error: $e";
    }
  }
}