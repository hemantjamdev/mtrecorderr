/*
import 'dart:developer';

import 'package:flutter/services.dart';

class LocalNotifications {
  static const _eChannel =
      EventChannel('com.example.notifications/notificationListener');
  static const _mChannel =
      MethodChannel('com.example.notifications/initNotification');

  static showNotification() {
    try {
      _mChannel.invokeMethod('initNotification');
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }

  static Stream<dynamic> get notificationStream =>
      _eChannel.receiveBroadcastStream();
}
*/
