import 'dart:convert';
import 'package:even_hub/models/event_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  final String _getApiUrl = "http://localhost:8080/api/events";

  //get all event data method
  Future<List<EventModel>> getAllData() async {
    try {
      final response = await http.get(Uri.parse(_getApiUrl));

      if (response.statusCode == 200) {
        List<dynamic> dataList = jsonDecode(response.body);

        List<EventModel> allData = dataList
            .map((e) => EventModel.fromJson(e))
            .toList();

        await Future.delayed(Duration(seconds: 3));

        return allData;
      } else {
        return [];
      }
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> createEvent(EventModel event) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('http://localhost:8080/api/events'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(event.toJson()), // EventModel එක JSON වලට හරවා යැවීම
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true; // සාර්ථකයි
    } else {
      print("Error: ${response.body}");
      return false; // අසාර්ථකයි
    }
  }

  //get events by user id
  Future<List<EventModel>> getMyEvents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
        'http://localhost:8080/api/events/my-events',
      ), // Backend Endpoint එක
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => EventModel.fromJson(e)).toList();
    } else {
      return []; // වැරද්දක් වුණොත් හිස් ලිස්ට් එකක් එවන්න
    }
  }

  Future<bool> updateEvent(EventModel event) async {
    print("🔄 Update Process Started for Event ID: ${event.id}"); // Check 1
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String baseUrl = 'http://localhost:8080/api/events';

      if (token == null) {
        print("❌ Error: Token is null!");
        return false;
      }

      print("📡 Sending PUT request to: $baseUrl/${event.id}"); // Check 2

      final response = await http.put(
        Uri.parse('$baseUrl/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(event.toJson()),
      );

      print("📊 Response Status Code: ${response.statusCode}"); // Check 3
      print("📋 Response Body: ${response.body}"); // Check 4

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Exception Caught: $e"); // Check 5
      return false;
    }
  }

  // --- Delete Event Method ---
  Future<bool> deleteEvent(int eventId) async {
    print("🗑️ Deleting Event ID: $eventId");
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/events/$eventId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("📊 Delete Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        return true;
      } else {
        print("❌ Delete Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Exception during delete: $e");
      return false;
    }
  }
}
