import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://localhost:8080/api/auth";

  //Register
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userName": name,
          "userEmail": email,
          "password": password,
          "role": "user",
        }),
      );

      print("Register Status: ${response.statusCode}");
      print("Register Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return await login(name, password);
      }
      return false;
    } catch (e) {
      print("Register Catch Error: $e");
      return false;
    }
  }

  //Login
  Future<bool> login(String username, String password) async {
    try {
      print("Attempting login for: $username");

      final response = await http.post(
        Uri.parse('$baseUrl/signin'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"userName": username, "password": password}),
      );

      print("Login Status Code: ${response.statusCode}");
      print("Login Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data['token'] ?? '');
        await prefs.setInt('userId', data['id'] ?? 0);
        await prefs.setString('userName', data['username'] ?? '');
        await prefs.setString('userEmail', data['email'] ?? '');
        await prefs.setString('userRole', data['role'] ?? 'user');

        print("Login Successful and Data Saved!");
        return true;
      } else if (response.statusCode == 401) {
        print("Error: Invalid credentials (401)");
        return false;
      } else {
        print("Error: Backend returned ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Login Connection Error: $e");
      return false;
    }
  }

  // --- Logout Function ---
  Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("User data cleared from storage");
  }
}
