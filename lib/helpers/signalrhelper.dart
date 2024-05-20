enum SignalrResponseEnum { success, failed }

enum SignalrEndpointsEnum {
  groupOpsCreateGroup,
  groupOpsCloseGroup,
  groupOpsKickMemberOut,
  groupOpsJoinGroup,
  groupOpsMemberLeavesGroup
}

class SignalrResponse {
  SignalrResponse(
      {required this.resultCode,
      this.resultTitle,
      required this.resultMessage,
      this.responseParams});

  final String resultCode;
  final String? resultTitle;
  final String resultMessage;
  final String? responseParams;

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
    responseParams: splitted[3],
  );
}

class SignalrMember {
  SignalrMember({required this.playerName, required this.connectionId});

  final String playerName;
  final String connectionId;
}

class SignalrMethods {
  SignalrMethods(
      {required this.endpointEnum,
      required this.methodName,
      required this.returnMethodName});

  final SignalrEndpointsEnum endpointEnum;
  final String methodName;
  final String returnMethodName;
}
