import 'package:party_games_by_tdng/helpers/apienvironmenthelper.dart';

ApiEnvironmentsEnum appEnvironment = ApiEnvironmentsEnum.testlocalhost;
String baseUrl = GetBaseUrl(appEnvironment);

class SignalrConstants {
  //hubs
  static String systemHub = "/System";
  static String hubOperations = "/HubOperations";
}
