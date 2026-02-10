import 'package:even_hub/main_screen.dart';
import 'package:even_hub/providers/logo_provider.dart';
import 'package:even_hub/providers/guest_provider.dart';
import 'package:even_hub/providers/index_change_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IndexChangeProvider()),
        ChangeNotifierProvider(create: (context) => LogoProvider()),
        ChangeNotifierProvider(create: (context) => GuestProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
