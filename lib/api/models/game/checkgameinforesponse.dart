// To parse this JSON data, do
//
//     final checkGameInfoResponse = checkGameInfoResponseFromJson(jsonString);

import 'dart:convert';

CheckGameInfoResponse checkGameInfoResponseFromJson(String str) =>
    CheckGameInfoResponse.fromJson(json.decode(str));

String checkGameInfoResponseToJson(CheckGameInfoResponse data) =>
    json.encode(data.toJson());

class CheckGameInfoResponse {
  dynamic roomCode;
  dynamic roomName;
  dynamic owner;
  dynamic gameId;
  String resultCode;
  String resultMessage;

  CheckGameInfoResponse({
    this.roomCode,
    this.roomName,
    this.owner,
    this.gameId,
    required this.resultCode,
    required this.resultMessage,
  });

  factory CheckGameInfoResponse.fromJson(Map<String, dynamic> json) =>
      CheckGameInfoResponse(
        roomCode: json["roomCode"],
        roomName: json["roomName"],
        owner: json["owner"],
        gameId: json["gameID"],
        resultCode: json["resultCode"],
        resultMessage: json["resultMessage"],
      );

  Map<String, dynamic> toJson() => {
        "roomCode": roomCode,
        "roomName": roomName,
        "owner": owner,
        "gameID": gameId,
        "resultCode": resultCode,
        "resultMessage": resultMessage,
      };
}
