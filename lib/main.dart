import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtrecorder/provider/ad_provider.dart';
import 'package:mtrecorder/record_app.dart';
import 'package:mtrecorder/utils/app_colors.dart';
import 'package:mtrecorder/utils/formate_duration.dart';
import 'package:mtrecorder/utils/strings.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Platform.isAndroid ? AdProvider.initAd() : null;
  runApp(const RecordApp());
}

@pragma("vm:entry-point")
void overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Sizer(builder: (context, orientation, deviceType) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayRecordingButton(),
    );
  }));
}
/*

@pragma("vm:entry-point")
void overlayMain1() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context)=>CameraFeedProvider(),
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SafeArea(
              child: Camera(),
            ),
          );
        }
      ),
    ),
  );
}

class Camera extends StatelessWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CameraFeed();
  }
}
*/

class OverlayRecordingButton extends StatefulWidget {
  const OverlayRecordingButton({Key? key}) : super(key: key);

  @override
  State<OverlayRecordingButton> createState() => _OverlayRecordingButtonState();
}

class _OverlayRecordingButtonState extends State<OverlayRecordingButton>
    with SingleTickerProviderStateMixin {
  bool showOption = false;
  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;

  bool isRecording = false;
  int text = 0;

  toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });
  }

  getData(Object? data) {
    if (data != null) {
      if (data.runtimeType == int) {
        setState(() {
          text = int.parse(data.toString());
        });
      } else if (data.runtimeType == bool) {
        isRecording = data as bool;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (homePort != null) return;
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameOverlay,
    );
    _receivePort.listen((message) {
      getData(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        elevation: 0,
        child: Center(
          child: GestureDetector(
              onTap: () {
                toggleRecording();

                homePort ??= IsolateNameServer.lookupPortByName(
                  _kPortNameHome,
                );
                homePort?.send(isRecording);
              },
              child: CircleAvatar(
                backgroundColor: AppColors.primarySwatch.withOpacity(0.6),
                child: Padding(
                  padding: EdgeInsets.all(isRecording ? 0.0 : 0.5),
                  child: isRecording
                      ? Text(
                          formatIntDuration(text),
                          style: const TextStyle(
                              color: AppColors.white, fontSize: 10),
                        )
                      : SvgPicture.asset(
                          isRecording ? Strings.stop : Strings.recordOnOff,
                          height: 30,
                          width: 30),
                ),
              )),
        ));
  }
}
