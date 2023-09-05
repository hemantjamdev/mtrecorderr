import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtrecorder/utils/strings.dart';

class NotificationProvider extends ChangeNotifier {
  final _eChannel = const EventChannel(Strings.eventChannel);
  final _mChannel = const MethodChannel(Strings.methodChannel);

  showNotification() {
    try {
      if (Platform.isAndroid) {
        _mChannel.invokeMethod(Strings.showNotification);
        _eChannel.receiveBroadcastStream();
      }
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }

  Stream<dynamic> get notificationStream => _eChannel.receiveBroadcastStream();
}
