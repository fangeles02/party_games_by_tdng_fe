import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:party_games_by_tdng/pages/interface/mainmenu.dart';
import 'package:party_games_by_tdng/pages/interface/username_nominate_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  var playerName = prefs.getString('player_name');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal, brightness: Brightness.light)),
    home: (playerName == null || playerName.isEmpty)
        ? const UsernameNominationPage()
        : const MainMenu(),
  ));
}
