import 'package:party_games_by_tdng/api/models/game/checkgameinforequest.dart';
import 'package:party_games_by_tdng/api/models/game/checkgameinforesponse.dart';
import 'package:party_games_by_tdng/api/restapiadapter.dart';

class GameAdapter {
  static Future<CheckGameInfoResponse> checkGameInfo(
      CheckGameInfoRequest request) async {
    CheckGameInfoResponse result;

    try {
      result = checkGameInfoResponseFromJson(
          (await RestApiAdapter.executeEndpoint(ApiConstants.checkgameInfo,
                  checkGameInfoRequestToJson(request))) ??
              "");
    } catch (ex, mess) {
      result = CheckGameInfoResponse(
          resultCode: "ERR", resultMessage: "Cannot connect to the server.");
    }

    return result;
  }
}
