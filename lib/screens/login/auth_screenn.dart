import 'package:even_hub/screens/admin_dashboard_screen.dart';
import 'package:even_hub/screens/login/login_screen.dart';
import 'package:even_hub/screens/usere_dashboard_screen.dart';
import 'package:even_hub/services/local_storage_service.dart';

import 'package:flutter/material.dart';

class AuthScreenn extends StatefulWidget {
  const AuthScreenn({super.key});

  @override
  State<AuthScreenn> createState() => _AuthScreennState();
}

class _AuthScreennState extends State<AuthScreenn> {
  @override
  void initState() {
    userRoalMethod();
    super.initState();
  }

  String userRoal = "No Roal";

  Future<void> userRoalMethod() async {
    String data = await LocalStorageService().getCurrentUserRoal();
    setState(() {
      userRoal = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalStorageService().isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.data == true) {
            return userRoal.toLowerCase() == "admin"
                ? const AdminDashboardScreen()
                : const UsereDashboardScreen();
          } else {
            return LoginScreen();
          }
        }
      },
    );
  }
}
