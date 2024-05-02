// To parse this JSON data, do
//
//     final checkGameInfoRequest = checkGameInfoRequestFromJson(jsonString);

import 'dart:convert';

CheckGameInfoRequest checkGameInfoRequestFromJson(String str) =>
    CheckGameInfoRequest.fromJson(json.decode(str));

String checkGameInfoRequestToJson(CheckGameInfoRequest data) =>
    json.encode(data.toJson());

class CheckGameInfoRequest {
  dynamic gameId;
  dynamic passcode;

  CheckGameInfoRequest({
    required this.gameId,
    required this.passcode,
  });

  factory CheckGameInfoRequest.fromJson(Map<String, dynamic> json) =>
      CheckGameInfoRequest(
        gameId: json["gameID"],
        passcode: json["passcode"],
      );

  Map<String, dynamic> toJson() => {
        "gameID": gameId,
        "passcode": passcode,
      };
}
