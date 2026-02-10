import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Web වලදී localhost සමඟ 127.0.0.1 පාවිච්චි කිරීම වඩාත් විශ්වාසදායකයි
  final String baseUrl = "http://localhost:8080/api/auth";

  // --- Register Function ---
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
        // Register වුණාට පස්සේ කෙලින්ම Login කරමු
        return await login(name, password);
      }
      return false;
    } catch (e) {
      print("Register Catch Error: $e");
      return false;
    }
  }

  // --- Login Function ---
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

      // Console එකේ මේ ටික බලන්න
      print("Login Status Code: ${response.statusCode}");
      print("Login Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        // Token එක සහ User විස්තර Save කිරීම
        // Backend එකෙන් එන Key names (token, id, username) නිවැරදිදැයි පරීක්ෂා කරන්න
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
      // Connection එකේ ප්‍රශ්නයක් නම් මෙතන ප්‍රින්ට් වෙයි
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
