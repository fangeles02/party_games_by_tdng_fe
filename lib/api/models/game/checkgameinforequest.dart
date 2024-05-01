// To parse this JSON data, do
//
//     final checkGameInfoRequest = checkGameInfoRequestFromJson(jsonString);

import 'dart:convert';

CheckGameInfoRequest checkGameInfoRequestFromJson(String str) =>
    CheckGameInfoRequest.fromJson(json.decode(str));

String checkGameInfoRequestToJson(CheckGameInfoRequest data) =>
    json.encode(data.toJson());

class CheckGameInfoRequest {
  String gameId;
  String passcode;
  String token;

  CheckGameInfoRequest({
    required this.gameId,
    required this.passcode,
    required this.token,
  });

  factory CheckGameInfoRequest.fromJson(Map<String, dynamic> json) =>
      CheckGameInfoRequest(
        gameId: json["gameID"],
        passcode: json["passcode"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "gameID": gameId,
        "passcode": passcode,
        "token": token,
      };
}
