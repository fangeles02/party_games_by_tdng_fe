
 bool isDevelopment = true;

class ApiConstants {
  static String baseUrl = isDevelopment == true ? 'http://172.17.64.1:5001' : "";
  static String sampleEndpoint = '/WeatherForecast/Sample';
}



class SignalrConstants
{
  static String baseUrl = isDevelopment == true ? 'http://172.17.64.1:5001' : "";

  //hubs
  static String systemHub = "/System";
  static String hubOperations = "/HubOperations";
}