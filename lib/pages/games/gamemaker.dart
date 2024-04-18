import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:party_games_by_tdng/api/appsettings.dart';
import 'package:party_games_by_tdng/helpers/gamedetailshelper.dart';
import 'package:party_games_by_tdng/helpers/responsiveuihelper.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:animations/animations.dart';

class GameMaker extends StatefulWidget {
  const GameMaker({super.key, required this.gameDetail, required this.heroTag});

  final GameDetails gameDetail;
  final String heroTag;

  @override
  State<GameMaker> createState() => _GameMakerState();
}

class _GameMakerState extends State<GameMaker> {
  Function()? continuebuttonfunc;

  int currentIndex = 0;
  String continuebuttontext = "Connecting";
  TextEditingController gamenameinputcontroller = TextEditingController();
  TextEditingController passcodeinputcontroller = TextEditingController();
  bool isconnected = false;
  bool isnotconnected = true;

  continueButton() async {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) => Sample(
    //             sampleData: "Hello Sample", initHubConnection: connection)));
    setState(() {
      currentIndex = 1;
    });
  }

  final connection = HubConnectionBuilder()
      .withUrl(
          baseUrl + SignalrConstants.hubOperations,
          HttpConnectionOptions(
            logging: (level, message) => print(message),
          ))
      .build();

  void initSignalR() async {
    try {
      await connection.start();
      setState(() {
        continuebuttonfunc = continueButton;
        continuebuttontext = "Continue";
        isconnected = true;
      });
    } on Exception catch (data) {
      print(data.toString());
      setState(() {
        continuebuttonfunc = null;
        continuebuttontext = "Failed to connect";
        isconnected = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSignalR();
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

    void onTapped(int index) {
      setState(() {
        currentIndex = index;
        print(currentIndex);
      });
    }

    List<Widget> pages = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    globalLeftRightPadding, 0, globalLeftRightPadding, 0),
                child: Column(
                  children: [
                    Text(
                      widget.gameDetail.gameTitle,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.gameDetail.gameDescription,
                      textAlign: TextAlign.justify,
                    ),
                    TextButton(
                      onPressed: continuebuttonfunc,
                      child: Text(continuebuttontext),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      ExcludeSemantics(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              globalLeftRightPadding, 0, globalLeftRightPadding, 0),
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              SafeArea(child: Container()),
              Visibility(
                  visible: !isconnected,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Cannot create game",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const Text(
                          "It seems there was a problem connecting to the server or there are issues with your internet connection. Please try again at a later time."),
                    ],
                  )),
              Visibility(
                visible: isconnected,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Configure your game",
                      style: TextStyle(fontSize: 18),
                    ),
                    const Text(
                        "In order for others to join this game, they need to provide the game ID and passcode"),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                        child: Column(
                      children: [
                        TextFormField(
                          controller: gamenameinputcontroller,
                          decoration: const InputDecoration(
                            label: Text("Game ID"),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passcodeinputcontroller,
                          decoration: const InputDecoration(
                            label: Text(
                              "Passcode",
                            ),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          obscureText: false,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        color: Colors.red,
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (currentIndex == 1 || currentIndex == 2) {
          setState(() {
            currentIndex = 0;
          });
        } else {
          if (isconnected) {
            if (didPop) {
              return;
            }

            bool res = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Confirmation"),
                      content: const Text(
                          "Are you sure you want to go back? Any games in progress will be ended immediately."),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text("No")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text("Yes")),
                      ],
                    ));

            if (res == true) {
              Navigator.pop(context);
            }
          } else {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark),
        ),
        body: PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) =>
              FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
          child: pages.elementAt(currentIndex),
        ),

        // {
        //           return FadeThroughTransition(
        //             animation: animation,
        //             secondaryAnimation: secondaryAnimation,
        //             child: child,
        //           );
        //         },

        //

        // _NavigationDestinationView(
        //       // Adding [UniqueKey] to make sure the widget rebuilds when transitioning.
        //       key: UniqueKey(),
        //       item: bottomNavigationBarItems[_currentIndex.value],
        //     )

        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.info), label: "Introduction"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setup"),
            BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: "Game")
          ],
          currentIndex: currentIndex,
          onTap: onTapped,
        ),
      ),
    );
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    await connection.stop();
  }
}

class Sample extends StatefulWidget {
  const Sample(
      {super.key, required this.sampleData, required this.initHubConnection});

  final String sampleData;
  final HubConnection initHubConnection;

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  void inittt() {
    widget.initHubConnection.on('CreateGroupResponse', (message) {
      print(message.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inittt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sampleData),
      ),
      body: Container(
        child: ElevatedButton(
          onPressed: () async {
            await widget.initHubConnection.invoke('CreateGroup',
                args: ["token", "Fernan", "For the WHITE", "12345", "Mafia"]);
          },
          child: const Text("Click me"),
        ),
      ),
    );
  }
}
