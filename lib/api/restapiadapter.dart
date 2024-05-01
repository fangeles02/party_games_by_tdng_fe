import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:party_games_by_tdng/api/appsettings.dart';
import 'package:party_games_by_tdng/helpers/jwttokenhelper.dart';

class RestApiAdapter {
  static Future<String?> executeEndpoint(
      String endpoint, String request) async {
    String token = generateJwtToken();

    try {
      var url = Uri.parse(baseUrl + endpoint);
      var response = await http.post(url, body: request, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 401) {
        //print("unauthorized");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

class ApiConstants {
  //api endpoints
  static String sampleEndpoint = '/WeatherForecast/Sample';

  //game endpoints
  static String checkgameInfo = '/Game/CheckGameInfo';
}
