import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:party_games_by_tdng/api/appsettings.dart';

class RestApiAdapter {
  static Future<String?> executeEndpoint(
      String endpoint, String request) async {
    try {
      var url = Uri.parse(baseUrl + endpoint);
      var response = await http.post(url,
          body: request, headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        return response.body;
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
