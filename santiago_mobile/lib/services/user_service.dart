import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class UserService {
  static Map<String, dynamic> data = {};

  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    http.Response response = await http.post(Uri.parse('${AppConstants.baseUrl}/api/users/login'),
        body: {"email": email, "password": password});
    
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
  
  // Save data into SharedPreferences
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', userData['firstName'] ?? '');
    await prefs.setString('token', userData['token'] ?? '');
    await prefs.setString('type', userData['type'] ?? '');
  }
  
  // Retrieve User Data from SharedPreferences
  static Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'firstName': prefs.getString('firstName') ?? '',
      'token': prefs.getString('token') ?? '',
      'type': prefs.getString('type') ?? '',
    };
  }
  
  // Check if User is Logged In
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }
  
  // Logout and Clear User Data
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  // New method for registration
  static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    http.Response response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/api/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    
    if (response.statusCode == 201) {
      data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to register user');
    }
  }
}