import 'package:party_games_by_tdng/helpers/apienvironmenthelper.dart';

ApiEnvironmentsEnum appEnvironment = ApiEnvironmentsEnum.testserver;
String baseUrl = GetBaseUrl(appEnvironment);

class ApiConstants {
  //api endpoints
  static String sampleEndpoint = '/WeatherForecast/Sample';
}

class SignalrConstants {
  //hubs
  static String systemHub = "/System";
  static String hubOperations = "/HubOperations";
}
