import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraEventHandlers {
  /*
  * RtcEngine engine is agora initialized engine.
  * timePassed accepts integer and hold the value of time in ms that has passed after the call hans been triggered by the local user.
  */
  static void onJoinChannelSuccess(RtcEngine engine, int timePassed) {}

  static void onUserJoined(
      RtcConnection connection, int remoteUid, int elapsed) {}

  static void onUserLeaveChannel(RtcConnection connection) {}
}
