import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:party_games_by_tdng/api/appsettings.dart';
import 'package:party_games_by_tdng/helpers/gamedetailshelper.dart';
import 'package:party_games_by_tdng/helpers/hubmethodshelper.dart';
import 'package:party_games_by_tdng/helpers/jwttokenhelper.dart';
import 'package:party_games_by_tdng/helpers/responsiveuihelper.dart';
import 'package:party_games_by_tdng/helpers/signalrhelper.dart';
import 'package:party_games_by_tdng/pages/interface/loaderscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  final gamecredskey = GlobalKey<FormState>();
  Color appbarforegroundcolor = Colors.white;
  SystemUiOverlayStyle systembarbrightness = SystemUiOverlayStyle.light;

  String continuebuttontext = "Connecting";
  TextEditingController gamenameinputcontroller = TextEditingController();
  TextEditingController passcodeinputcontroller = TextEditingController();
  bool isconnected = false;
  bool isnotconnected = true;
  String? playerName;

  bool isClosingFromMainUi = true;

  bool isCreateGroupSuccess = false;

  int currentIndexPage = 0;
  int currentIndexBottomNavigationBar = 0;

  Function()? buttonCreateFunctionOnClick;
  String buttonCreateText = "Create game";
  ButtonStyle? buttonCreateStyle;

  ButtonStyle buttonCreateDefaultStyle =
      const ButtonStyle(backgroundColor: null, foregroundColor: null);

  ButtonStyle buttonCreateActiveStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.red),
      foregroundColor: MaterialStateProperty.all(Colors.white));
  //Color buttonCreateColor =

  List<SignalrMember> playersList = List.empty(growable: true);

  creategameButton() async {
    if (gamecredskey.currentState!.validate()) {
      setState(() {
        buttonCreateFunctionOnClick = null;
        buttonCreateText = "Creating game";
      });

      await connection.invoke(
          getMethodDetails(SignalrEndpointsEnum.mafiaCreateGroup).methodName,
          args: [
            generateJwtToken(),
            playerName,
            gamenameinputcontroller.text,
            passcodeinputcontroller.text,
            widget.gameDetail.gameId
          ]);
    }
  }

  closegamebutton() async {
    isClosingFromMainUi = true;

    var res = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Confirmation"),
              content: const Text(
                  "Do you want to end the current game? Other connected players will be disconnected."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text("No")),
              ],
            ));

    if (res) {
      setState(() {
        buttonCreateText = "Ending game";
        buttonCreateStyle = buttonCreateDefaultStyle;
        buttonCreateFunctionOnClick = null;
      });

      await connection.invoke(
          getMethodDetails(SignalrEndpointsEnum.mafiaCloseGroup).methodName,
          args: [
            generateJwtToken(),
            gamenameinputcontroller.text,
            passcodeinputcontroller.text,
            widget.gameDetail.gameId
          ]);
    }
  }

  continueButton() async {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) => Sample(
    //             sampleData: "Hello Sample", initHubConnection: connection)));
    setState(() {
      if (isCreateGroupSuccess) {
        currentIndexPage = 3;
      } else {
        currentIndexPage = 1;
      }
      currentIndexBottomNavigationBar = 1;

      appbarforegroundcolor = Colors.black;
      systembarbrightness = SystemUiOverlayStyle.dark;
    });
  }

  final connection = HubConnectionBuilder()
      .withUrl(
          baseUrl + SignalrConstants.hubOperations,
          HttpConnectionOptions(
            logging: (level, message) => print(message),
          ))
      .withAutomaticReconnect(true)
      .build();

  void initSignalR() async {
    try {
      await connection.start();
      setState(() {
        continuebuttonfunc = continueButton;
        continuebuttontext = "Continue";
        isconnected = true;
      });

      buttonCreateFunctionOnClick = creategameButton;
      buttonCreateStyle = buttonCreateDefaultStyle;

      connection.onclose((exception) {
        print("The connection has been forcedly closed charing");
      });

      connection.on(
          getMethodDetails(SignalrEndpointsEnum.mafiaCreateGroup)
              .returnMethodName, (message) {
        SignalrResponse response =
            deserializeSignalrResponse(message.toString());

        if (response.result == SignalrResponseEnum.success) {
          setState(() {
            isCreateGroupSuccess = true;
            buttonCreateText = "End game";
            buttonCreateStyle = buttonCreateActiveStyle;
            buttonCreateFunctionOnClick = closegamebutton;
            currentIndexPage = 3;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.resultMessage),
            backgroundColor: Colors.green,
          ));
        } else {
          setState(() {
            isCreateGroupSuccess = false;
            buttonCreateText = "Create game";
            buttonCreateStyle = buttonCreateDefaultStyle;
            buttonCreateFunctionOnClick = creategameButton;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.resultMessage),
            backgroundColor: Colors.red,
          ));
        }
      });

      connection.on(
          getMethodDetails(SignalrEndpointsEnum.mafiaCloseGroup)
              .returnMethodName, (message) {
        SignalrResponse response =
            deserializeSignalrResponse(message.toString());

        if (isClosingFromMainUi) {
          if (response.result == SignalrResponseEnum.success) {
            setState(() {
              isCreateGroupSuccess = false;
              buttonCreateText = "Create game";
              buttonCreateStyle = buttonCreateDefaultStyle;
              buttonCreateFunctionOnClick = creategameButton;
              currentIndexPage = 1;
            });

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(response.resultMessage),
            ));
          } else {
            setState(() {
              isCreateGroupSuccess = true;
              buttonCreateText = "End game";
              buttonCreateStyle = buttonCreateActiveStyle;
              buttonCreateFunctionOnClick = closegamebutton;
            });

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(response.resultMessage),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          Navigator.pop(context, true);

          if (response.result == SignalrResponseEnum.success) {
            Navigator.pop(context, true);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(response.resultMessage),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(response.resultMessage),
              backgroundColor: Colors.red,
            ));
          }
        }
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

  void initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   playerName = prefs.getString('player_name');
    // });
    playerName = prefs.getString('player_name');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPrefs();
    initSignalR();
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

    void onBottomNavigationBarTapped(int index) {
      setState(() {
        currentIndexBottomNavigationBar = index;

        switch (index) {
          case 0:
            currentIndexPage = index;
            break;
          case 1:
            if (isCreateGroupSuccess) {
              currentIndexPage = 3;
            } else {
              currentIndexPage = index;
            }
            break;
          case 2:
            currentIndexPage = index;
            break;
        }

        if (index == 0) {
          appbarforegroundcolor = Colors.white;
          systembarbrightness = SystemUiOverlayStyle.light;
        } else {
          appbarforegroundcolor = Colors.black;
          systembarbrightness = SystemUiOverlayStyle.dark;
        }
      });
    }

    List<Widget> pages = [
      Column(
        key: const ValueKey<int>(0),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            child: Stack(children: [
              Image.asset(
                widget.gameDetail.imageSource ?? "",
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
                    widget.gameDetail.gameTitle,
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
                  children: [
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
        key: const ValueKey<int>(1),
        child: Container(
          padding: EdgeInsets.fromLTRB(
              globalLeftRightPadding, 0, globalLeftRightPadding, 0),
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              SafeArea(child: Container()),
              Visibility(
                  visible: !isconnected,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cannot create game",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "It seems that there was a problem connecting to the server or there are issues with your internet connection. Please try again at a later time."),
                    ],
                  )),
              Visibility(
                visible: isconnected,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        key: gamecredskey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              enabled: !isCreateGroupSuccess,
                              controller: gamenameinputcontroller,
                              decoration: const InputDecoration(
                                label: Text("Game ID"),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              validator: (value) {
                                return (value == null || value.isEmpty)
                                    ? "Game ID is required"
                                    : null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              enabled: !isCreateGroupSuccess,
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
                              validator: (value) {
                                return (value == null || value.isEmpty)
                                    ? "Passcode is required"
                                    : null;
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: defaultButtonHeight,
                      child: ElevatedButton(
                        onPressed: buttonCreateFunctionOnClick,
                        style: buttonCreateStyle,
                        child: Text(buttonCreateText),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        key: const ValueKey<int>(2),
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text("Item $index"),
              );
            }),
      ),
      //page 4 (page 2 of connected state)
      Column(
        key: const ValueKey<int>(3),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(child: Container()),
          Padding(
            padding: EdgeInsets.fromLTRB(
                globalLeftRightPadding, 0, globalLeftRightPadding, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Configure your game",
                  style: TextStyle(fontSize: 18),
                ),
                const Text(
                    "Please provide your co-players this game ID and passcode"),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Game ID:"),
                            Text(
                              gamenameinputcontroller.text,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Passcode:"),
                            Text(
                              passcodeinputcontroller.text,
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                        SizedBox(
                          height: defaultButtonHeight,
                          child: ElevatedButton(
                            onPressed: buttonCreateFunctionOnClick,
                            style: buttonCreateStyle,
                            child: const Icon(Icons.stop),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                const Text("Members"),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  shrinkWrap: true,
                  itemCount: playersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle),
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(playersList[index].playerName),
                      subtitle: Text(playersList[index].connectionId),
                      trailing: SizedBox(
                        width: 50,
                        height: 50,
                        child: ListViewRemoveButton(
                          onButtonTapped: () {
                            var playerdata = playersList[index];
                            setState(() {
                              playersList.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                globalLeftRightPadding, 20, globalLeftRightPadding, 20),
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      playersList!.add(SignalrMember(
                          playerName: "Sample player", connectionId: "12345"));
                    });
                  },
                  child: const Text("data")),
            ),
          )
        ],
      )
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (currentIndexPage == 1 ||
            currentIndexPage == 2 ||
            currentIndexPage == 3) {
          setState(() {
            currentIndexPage = 0;

            appbarforegroundcolor = Colors.white;
            systembarbrightness = SystemUiOverlayStyle.light;
          });
        } else {
          if (isCreateGroupSuccess) {
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
                            onPressed: () async {
                              isClosingFromMainUi = false;

                              Navigator.pop(context, true);

                              showDialog(
                                  barrierColor: Colors.black87,
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => const LoaderScreen(
                                        prompt:
                                            "Attempting to end current game",
                                      ));

                              await connection.invoke(
                                  getMethodDetails(
                                          SignalrEndpointsEnum.mafiaCloseGroup)
                                      .methodName,
                                  args: [
                                    generateJwtToken(),
                                    gamenameinputcontroller.text,
                                    passcodeinputcontroller.text,
                                    widget.gameDetail.gameId
                                  ]);
                            },
                            child: const Text("Yes")),
                      ],
                    ));

            if (res == true) {
              //Navigator.pop(context);
            }
          } else {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          foregroundColor: appbarforegroundcolor,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: systembarbrightness,
        ),
        body: PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) =>
              FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
          child: pages.elementAt(currentIndexPage),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.info), label: "Overview"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setup"),
            BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: "Game"),
          ],
          currentIndex: currentIndexBottomNavigationBar,
          onTap: onBottomNavigationBarTapped,
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

class ListViewRemoveButton extends StatelessWidget {
  const ListViewRemoveButton({super.key, required this.onButtonTapped});

  final Function() onButtonTapped;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.orange[100],
      onPressed: onButtonTapped,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: const Icon(Icons.exit_to_app),
    );
  }
}
