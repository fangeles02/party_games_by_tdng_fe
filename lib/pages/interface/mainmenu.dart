import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:party_games_by_tdng/helpers/gamedetailshelper.dart';
import 'package:party_games_by_tdng/helpers/responsiveuihelper.dart';
import 'package:party_games_by_tdng/pages/games/gamemaker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  String? playername = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      playername = prefs.getString('player_name');
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    double globalLeftRightPadding =
        responsiveUiHelper().isSmallScreen(mediaQueryData.size.width)
            ? 20
            : (responsiveUiHelper().isMediumScreen(mediaQueryData.size.width)
                ? 50
                : 70);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              globalLeftRightPadding, 8, globalLeftRightPadding, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome, ${playername ?? ""}!",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  const Text("Some subheaders and greeting content")
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomCardButton(
                heroTag: "b",
                onClick: () {},
                title: "Join",
                subtitle: "Join an existing game",
              ),
              const SizedBox(
                height: 35,
              ),
              const Text(
                "New Game",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const Text("Start a new game as the game master"),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 5,
                direction: Axis.horizontal,
                children: [
                  CustomCardButton(
                    heroTag: "game_title_mafia",
                    onClick: () {
                     Navigator.push(context, MaterialPageRoute(builder: (_) => GameMaker(
                       heroTag: "game_title_mafia",
                        gameDetail: gameSelector(Game.mafia),
                      )));
                    },
                    title: "Mafia",
                    subtitle: "A Thrilling Social Deduction Game",
                  ),
                  CustomCardButton(
                    heroTag: "a",
                    onClick: () {},
                    title: "Draw me",
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: const NavigationDrawer(
        children: [],
      ),
    );
  }
}

class CustomCardButton extends StatelessWidget {
  const CustomCardButton(
      {super.key, required this.onClick, required this.title, this.subtitle, required this.heroTag});

  final String title;
  final String? subtitle;
  final Function() onClick;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.inversePrimary,
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: onClick,
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.primaryContainer),
        child: SizedBox(
          width: 150,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: heroTag,
                child: Text(
                  title,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                subtitle ?? "",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
