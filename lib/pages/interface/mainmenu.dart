import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:party_games_by_tdng/helpers/gamedetailshelper.dart';
import 'package:party_games_by_tdng/helpers/responsiveuihelper.dart';
import 'package:party_games_by_tdng/pages/games/gamemaker/gamemaker.dart';
import 'package:party_games_by_tdng/pages/games/joiner/joinagame.dart';
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
        ResponsiveUiHelper().isSmallScreen(mediaQueryData.size.width)
            ? smallScreenPadding
            : (ResponsiveUiHelper().isMediumScreen(mediaQueryData.size.width)
                ? mediumScreenPadding
                : largeScreenPadding);

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
                onClick: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => JoinGame()));
                },
                game: Game.joingame,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => GameMaker(
                                    heroTag: "game_title_mafia",
                                    gameDetail: gameSelector(Game.mafia),
                                  )));
                    },
                    game: Game.mafia,
                  ),
                  CustomCardButton(
                    heroTag: "a",
                    onClick: () {},
                    game: Game.sample,
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
      {super.key,
      required this.onClick,
      required this.game,
      required this.heroTag});

  final Function() onClick;
  final String heroTag;

  final Game game;

  GameDetails get gamedetails => gameSelector(game);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      splashColor: Theme.of(context).colorScheme.primaryContainer,
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          width: 170,
          height: 120,
          child: Stack(children: [
            Hero(
              tag: heroTag,
              child: Ink(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(gamedetails.imageSource ?? ""))),
              ),
            ),
            Ink(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromARGB(65, 0, 0, 0)),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gamedetails.gameTitle,
                    style: const TextStyle(
                        //color: Theme.of(context).colorScheme.onPrimaryContainer,
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    gamedetails.shortDescription,
                    style: const TextStyle(
                        //color: Theme.of(context).colorScheme.onPrimaryContainer
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
