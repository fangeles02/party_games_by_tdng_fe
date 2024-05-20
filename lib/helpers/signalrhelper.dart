enum SignalrResponseEnum { success, failed }

enum SignalrRecipient { self, group }

enum SignalrEndpointsEnum {
  groupOpsCreateGroup,
  groupOpsCloseGroup,
  groupOpsKickMemberOut,
  groupOpsJoinGroup,
  groupOpsMemberLeavesGroup
}

class SignalrResponse {
  SignalrResponse(
      {required this.recipient,
      required this.resultCode,
      this.resultTitle,
      required this.resultMessage,
      this.responseParams});

  final SignalrRecipient recipient;
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
    recipient:
        splitted[0] == "Self" ? SignalrRecipient.self : SignalrRecipient.group,
    resultCode: splitted[1],
    resultTitle: splitted[2],
    resultMessage: splitted[3],
    responseParams: splitted[4],
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
