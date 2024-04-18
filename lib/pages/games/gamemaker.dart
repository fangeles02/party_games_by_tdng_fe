import 'package:flutter/material.dart';
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

  continueButton() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => Sample(
                sampleData: "Hello Sample", initHubConnection: connection)));
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
      });
    } on Exception catch (data) {
      print(data.toString());
      setState(() {
        continuebuttonfunc = null;
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
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  globalLeftRightPadding, 0, globalLeftRightPadding, 0),
              child: Column(
                children: [
                  Hero(
                    tag: widget.heroTag,
                    child: Text(
                      widget.gameDetail.gameTitle,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
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
                    child: const Text("Continue"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      Container(
        color: Colors.blue,
      ),
      Container(
        color: Colors.red,
      ),
    ];

    return Scaffold(
      appBar: AppBar(),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pages.elementAt(currentIndex),
      ),

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
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    connection.stop();
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
