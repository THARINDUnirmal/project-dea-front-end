import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppMessages {
  Future<void> appAlertMessage({
    required BuildContext context,
    required void Function()? onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/lottie/Alerta.json", width: 100),
                Text(
                  "LogOut",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Are you sure you want to Logout?",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white54,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              onPressed: onPressed,
              child: Text("Yes", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text("No", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
