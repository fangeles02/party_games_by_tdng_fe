enum SignalrResponseEnum { success, failed }

class SignalrResponse {
  SignalrResponse(
      {required this.resultCode,
      this.resultTitle,
      required this.resultMessage});

  final String resultCode;
  final String? resultTitle;
  final String resultMessage;
  SignalrResponseEnum get result => resultCode == "OK"
      ? SignalrResponseEnum.success
      : SignalrResponseEnum.failed;
}

SignalrResponse deserializeSignalrResponse(String rawMessage) {
  String fixed = (rawMessage.replaceAll('[', '')).replaceAll(']', '');
  List<String> splitted = fixed.split('~');

  return SignalrResponse(
    resultCode: splitted[0],
    resultTitle: splitted[1],
    resultMessage: splitted[2],
  );
}
