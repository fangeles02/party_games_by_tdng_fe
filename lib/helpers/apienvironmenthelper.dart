enum ApiEnvironmentsEnum { testlocalhost, testserver, live }

class APIEnvironment {
  ApiEnvironmentsEnum environment;
  String baseUrl;

  APIEnvironment({
    required this.environment,
    required this.baseUrl,
  });
}

List<APIEnvironment> environments = [
  APIEnvironment(
      environment: ApiEnvironmentsEnum.live,
      baseUrl: "https://partygamesapi.thedotnetguy.com"),
  APIEnvironment(
      environment: ApiEnvironmentsEnum.testserver,
      baseUrl: "https://partygamesapitest.thedotnetguy.com"),
  APIEnvironment(
      environment: ApiEnvironmentsEnum.testlocalhost,
      baseUrl: "localhost:5001"),
];

String GetBaseUrl(ApiEnvironmentsEnum environment) {
  APIEnvironment env =
      environments.where((element) => element.environment == environment).first;
  return env.baseUrl;
}
