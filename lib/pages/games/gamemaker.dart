import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:party_games_by_tdng/api/api_constants.dart';
import 'package:party_games_by_tdng/helpers/gamedetailshelper.dart';
import 'package:party_games_by_tdng/helpers/responsiveuihelper.dart';
import 'package:signalr_core/signalr_core.dart';

class GameMaker extends StatefulWidget {
  const GameMaker({super.key, required this.gameDetail, required this.heroTag});

  final GameDetails gameDetail;
  final String heroTag;

  @override
  State<GameMaker> createState() => _GameMakerState();
}

class _GameMakerState extends State<GameMaker> {
  final connection = HubConnectionBuilder()
      .withUrl(
          SignalrConstants.baseUrl + SignalrConstants.hubOperations,
          HttpConnectionOptions(
            logging: (level, message) => print(message),
          ))
      .build();

  void initSignalR() async {
    await connection.start();
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

    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Sample(
                                    sampleData: "Hello Sample",
                                    initHubConnection: connection)));
                      },
                      child: const Text("Click me"))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
