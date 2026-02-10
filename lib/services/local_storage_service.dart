import 'package:even_hub/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  //to check the user is logged in ?
  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Token eka null nethnam user log wela inne
    if (token != null && token.isNotEmpty) {
      return true;
    }
    return false;
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  //get current user data
  Future<UserModel> getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel userData = UserModel(
      userId: pref.getInt('userId') ?? 0,
      name: pref.getString('userName') ?? "No Name",
      email: pref.getString('userEmail') ?? "No Email",
      role: pref.getString('userRole') ?? "No Roal",
    );

    return userData;
  }

  //get user roal
  Future<String> getCurrentUserRoal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String role = pref.getString('userRole') ?? "No Roal";

    return role;
  }
}
