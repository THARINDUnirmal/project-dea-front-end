import 'dart:convert';
import 'package:even_hub/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  final String _baseUrl = "http://localhost:8080/api/users";
  Future<List<dynamic>> getAllUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://localhost:8080/api/users'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load users");
    }
  }

  //New User Add
  Future<bool> registerUser(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  //User Update (Self or Admin)
  Future<bool> updateUser(int userId, Map<String, dynamic> userData) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.put(
        Uri.parse('$_baseUrl/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        print("User Updated Successfully");
        return true;
      } else {
        print("Update Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error updating user: $e");
      return false;
    }
  }

  // User Delete (Self or Admin)
  Future<bool> deleteUser(int userId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('$_baseUrl/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("User Deleted Successfully");
        return true;
      } else {
        print("Delete Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error deleting user: $e");
      return false;
    }
  }
}
