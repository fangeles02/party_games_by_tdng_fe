import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:party_games_by_tdng/api/gameadapter/gameadapter.dart';
import 'package:party_games_by_tdng/api/models/game/checkgameinforequest.dart';
import 'package:party_games_by_tdng/api/models/game/checkgameinforesponse.dart';
import 'package:party_games_by_tdng/api/restapiadapter.dart';
import 'package:party_games_by_tdng/helpers/jwttokenhelper.dart';
import 'package:party_games_by_tdng/helpers/gamedetailshelper.dart';
import 'package:party_games_by_tdng/helpers/responsiveuihelper.dart';
import 'package:signalr_core/signalr_core.dart';

class JoinGame extends StatefulWidget {
  const JoinGame({super.key});

  @override
  State<JoinGame> createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {
  TextEditingController groupname = TextEditingController();
  TextEditingController passcode = TextEditingController();

  int currentPage = 0;

  Function()? joinButtonFunc;
  String joinButtonText = "Join";

  bool gameFound = false;
  GameDetails gamedetails = gameSelector(Game.sample);

  //game group details
  String? gameID;
  String? gameCode;
  String? gameOwner;

  onJoinTappedTest() {
    var res = generateJwtToken();
    print(res);
  }

  onJoinTapped() async {
    setState(() {
      joinButtonFunc = null;
      joinButtonText = "Checking game";
    });

    var res = await GameAdapter.checkGameInfo(
        CheckGameInfoRequest(gameId: groupname.text, passcode: passcode.text));

    if (res.resultCode == "OK") {
      gameID = res.roomName;
      gameCode = res.roomCode;
      gameOwner = res.owner;

      //check game

      if (res.gameId == "Game.mafia") {
        gamedetails = gameSelector(Game.mafia);
        gameFound = true;
      } else {
        print("Game is not implemented yet");
      }

      if (gameFound) {
        setState(() {
          currentPage = 1;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(res.resultMessage),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      joinButtonFunc = onJoinTapped;
      joinButtonText = "Join";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  void initialize() {
    joinButtonFunc = onJoinTappedTest;
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

    List<Widget> pages = [
      ExcludeSemantics(
        key: const ValueKey<int>(0),
        child: Container(
            padding: EdgeInsets.fromLTRB(
                globalLeftRightPadding, 0, globalLeftRightPadding, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SafeArea(child: Container()),
                const Text(
                  "Join a Game",
                  style: TextStyle(fontSize: 18),
                ),
                const Text(
                    "In order for others to join this game, they need to provide the game ID and passcode"),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: groupname,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: "Game ID"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passcode,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: "Passcode",
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: defaultButtonHeight,
                      child: ElevatedButton(
                          onPressed: joinButtonFunc,
                          child: Text(joinButtonText)),
                    ),
                  ],
                ))
              ],
            )),
      ),
      ExcludeSemantics(
        child: Column(
          key: const ValueKey<int>(0),
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              child: Stack(children: [
                Image.asset(
                  gamedetails.imageSource,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    colors: [Color.fromARGB(189, 0, 0, 0), Colors.transparent],
                    stops: [0.3, 0.7],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(globalLeftRightPadding, 0, 0, 15),
                    child: Text(
                      gamedetails.gameTitle,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      globalLeftRightPadding, 0, globalLeftRightPadding, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        gamedetails.gameDescription,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("You are joining:"),
                                  Text(
                                    "$gameOwner's game",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: defaultButtonHeight,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      foregroundColor: MaterialStatePropertyAll(
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                  onPressed: () {},
                                  child: const Text("Join"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: PageTransitionSwitcher(
            transitionBuilder: (child, animation, secondaryAnimation) =>
                FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
            child: pages.elementAt(currentPage),
          )),
      onPopInvoked: (didPop) {
        if (didPop) {
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}
