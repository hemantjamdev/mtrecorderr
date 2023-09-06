import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/check_android_version.dart';

class PermissionProvider with ChangeNotifier {
  PermissionProvider() {
    checkPermissionStatus();
  }

  PermissionStatus storage = PermissionStatus.denied;
  PermissionStatus microphone = PermissionStatus.denied;
  PermissionStatus camera = PermissionStatus.denied;

  Future<PermissionStatus?> requestCameraPermission() async {
    camera = await Permission.camera.status;

    if (!camera.isGranted) {
      camera = await Permission.camera.request();
    }
    notifyListeners();
    return camera;
  }

  Future<void> checkPermissionStatus() async {
    if (Platform.isAndroid) {
      bool isAndroid30OrAbove = await checkAndroidVersion();
      storage = isAndroid30OrAbove
          ? await Permission.manageExternalStorage.status
          : await Permission.storage.status;
    }
    if (Platform.isIOS) {
      storage = await Permission.storage.status;
    }
    microphone = await Permission.microphone.status;
    camera = await Permission.camera.status;
    notifyListeners();
  }

  Future<PermissionStatus?> requestStoragePermission() async {
    if (Platform.isAndroid) {
      bool isAndroid30OrAbove = await checkAndroidVersion();
      storage = isAndroid30OrAbove
          ? await Permission.manageExternalStorage.request()
          : await Permission.storage.request();
    }
    if (Platform.isIOS) {
      storage = await Permission.storage.request();
    }
    notifyListeners();
    return storage;
  }

  Future<PermissionStatus?> requestMicrophonePermission() async {
    microphone = Platform.isIOS
        ? await Permission.camera.request()
        : await Permission.microphone.request();
    notifyListeners();
    return microphone;
  }


}
