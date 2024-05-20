import 'package:party_games_by_tdng/helpers/signalrhelper.dart';

List<SignalrMethods> hubMethods = [
  SignalrMethods(
      endpointEnum: SignalrEndpointsEnum.groupOpsCreateGroup,
      methodName: "CreateGroup",
      returnMethodName: "CreateGroupResponse"),
  SignalrMethods(
      endpointEnum: SignalrEndpointsEnum.groupOpsCloseGroup,
      methodName: "CloseGroup",
      returnMethodName: "CloseGroupResponse"),
  SignalrMethods(
      endpointEnum: SignalrEndpointsEnum.groupOpsKickMemberOut,
      methodName: "KickMemberOut",
      returnMethodName: "KickMemberOutResponse"),
  SignalrMethods(
      endpointEnum: SignalrEndpointsEnum.groupOpsJoinGroup,
      methodName: "JoinGroup",
      returnMethodName: "JoinGroupResponse"),
  SignalrMethods(
      endpointEnum: SignalrEndpointsEnum.groupOpsMemberLeavesGroup,
      methodName: "MemberLeavesGroup",
      returnMethodName: "MemberLeavesGroupResponse"),
];

SignalrMethods getMethodDetails(SignalrEndpointsEnum endpoint) {
  return hubMethods.where((element) => element.endpointEnum == endpoint).first;
}
