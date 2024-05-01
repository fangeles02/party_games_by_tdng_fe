import 'package:party_games_by_tdng/helpers/signalrhelper.dart';

List<SignalrMethods> hubMethods = [
  SignalrMethods(
      endpointEnum: SignalrEndpointsEnum.mafiaCreateGroup,
      methodName: "CreateGroup",
      returnMethodName: "CreateGroupResponse"),
  SignalrMethods(
      endpointEnum: SignalrEndpointsEnum.mafiaCloseGroup,
      methodName: "CloseGroup",
      returnMethodName: "CloseGroupResponse"),
  SignalrMethods(
      endpointEnum: SignalrEndpointsEnum.mafiaJoinGame,
      methodName: "JoinGame",
      returnMethodName: "JoinGameResponse"),
];

SignalrMethods getMethodDetails(SignalrEndpointsEnum endpoint) {
  return hubMethods.where((element) => element.endpointEnum == endpoint).first;
}
