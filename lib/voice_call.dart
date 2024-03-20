import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_voice_video/AgoraEventHandlers.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = "34901eefd3634abbaacf3b988b609f00";
const channel = "myChannel";

class VoiceCall extends StatefulWidget {
  const VoiceCall(
      {super.key, required this.channelName, this.uid = 0, this.token = ""});
  final String channelName;
  final String token;
  final int uid;
  @override
  State<VoiceCall> createState() => _VoiceCallState();
}

class _VoiceCallState extends State<VoiceCall> {
  late final RtcEngine _engine;
  bool isJoined = false;
  bool openMicrophone = false;
  bool enableSpeakerphone = false;
  int msElappsed = 0;

  @override
  void initState() {
    super.initState();
    initCameraMic();
    initializeAgora(widget.channelName, widget.uid, widget.token);
  }

  Future<void> initCameraMic() async {
    await [Permission.microphone].request();
  }

  initializeAgora(String channelName, int uid, String token) async {
    _engine = createAgoraRtcEngine();
    _engine.setLogLevel(LogLevel.logLevelNone);
    await _engine.initialize(const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication1v1));

    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        debugPrint("local user ${connection.localUid} joined");
        _engine.setEnableSpeakerphone(enableSpeakerphone);
        setState(() {
          msElappsed = elapsed;
        });
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        debugPrint("remote user $remoteUid joined");
      },
      onLeaveChannel: (connection, stats) {
        debugPrint("Call Stats ${stats.toJson()} ");
      },
      onUserOffline: (connection, remoteUid, reason) {
        debugPrint("remote user $remoteUid left channel");
        debugPrint("remote user Left:  ${reason.toString()}");
      },
      onError: (err, msg) {
        debugPrint(err.toString());
        debugPrint(msg.toString());
      },
      onTokenPrivilegeWillExpire: (connection, token) => {},
    ));

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: const ChannelMediaOptions());
    await _engine.enableInEarMonitoring(
        enabled: true,
        includeAudioFilters:
            EarMonitoringFilterType.earMonitoringFilterBuiltInAudioFilters);
  }

  void toggleMuteCall() {
    _engine.muteLocalAudioStream(!openMicrophone).then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    });
  }

  void switchSpeakerphone() {
    _engine.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    });
  }

  Future<void> disposeAgora() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  void dispose() {
    super.dispose();
    disposeAgora();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("User Connected"),
            Text("$msElappsed"),
            ElevatedButton.icon(
                onPressed: () {
                  toggleMuteCall();
                },
                icon: const Icon(Icons.mic),
                label: Text(!openMicrophone ? "Mute" : "Un Mute")),
            ElevatedButton.icon(
                onPressed: () {
                  switchSpeakerphone();
                },
                icon: const Icon(Icons.speaker),
                label: Text(enableSpeakerphone ? "Speaker On" : "Speaker Off")),
            ElevatedButton.icon(
                onPressed: () {
                  disposeAgora().then((value) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
                icon: const Icon(Icons.call_end),
                label: Text("End Call"))
          ],
        ),
      )),
    );
  }
}
