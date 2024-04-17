import 'package:flutter/material.dart';
import 'package:party_games_by_tdng/pages/interface/mainmenu.dart';
import 'package:party_games_by_tdng/pages/interface/username_nominate_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  var playerName = prefs.getString('player_name');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal, brightness: Brightness.light)),
    home: (playerName == null || playerName.isEmpty) ? const UsernameNominationPage() : const MainMenu(),
  ));
}
