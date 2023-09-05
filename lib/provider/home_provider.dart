import 'dart:async';

import 'package:disk_space/disk_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mtrecorder/utils/shared_prefs.dart';
import 'package:mtrecorder/widgets/custom_overlay.dart';


import '../utils/folder_size.dart';
import '../utils/storage_convert.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider() {
    checkOverLay();
  }

  checkOverLay() async {
    overlayActive = await FlutterOverlayWindow.isActive();
    cameraOverlay = await SharePrefs.getValue("cameraFeed");
    notifyListeners();
  }

  double totalSpace = 0;
  double freeSpace = 0;
  String totalStorage = "";
  int index = 0;
  String? formattedSize;
  bool cameraOverlay = false;
  int count = 3;
  bool showFeed = false;
  bool overlayActive = false;

  void startCountdown() async {
    for (int i = 3; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1), () {
        //setState(() {
        count = i;
        notifyListeners();
        // });
      });
    }
  }

  toggleFeed() {
    showFeed = !showFeed;
    notifyListeners();
  }

/*
  void toggleCameraOverlay(BuildContext context) async {
    if (await overlayWindowsPlugin.isPermissionGranted()) {
      cameraOverlay = await SharePrefs.getValue("cameraFeed");
      if (cameraOverlay) {
        log("overlay active-----");
        await overlayWindowsPlugin.closeOverlayWindow("cameraFeed");
        SharePrefs.setValue("cameraFeed", false);

        cameraOverlay = false;
      } else {
        log("showing overlay -----");

        await overlayWindowsPlugin.showOverlayWindow(
            "cameraFeed",
            "overlayMain1",
            OverlayWindowConfig(
              width: 300,
              height: 300,
              enableDrag: true,
            ));
        SharePrefs.setValue("cameraFeed", true);

        cameraOverlay = true;
      }
    } else {
      await overlayWindowsPlugin.requestPermission();
    }
    notifyListeners();
  }
*/

  toggleOverlay() async {
    final bool status = await FlutterOverlayWindow.isPermissionGranted();

    if (!status) {
      await FlutterOverlayWindow.requestPermission();
    }
    if (await FlutterOverlayWindow.isActive()) {
      overlayActive = false;
      await FlutterOverlayWindow.closeOverlay();
    } else if (!await FlutterOverlayWindow.isActive()) {
      overlayActive = true;
      await show(); /*FlutterOverlayWindow.showOverlay(
        enableDrag: true,
        height: 400,
        width: 400,
      );*/
    }
    notifyListeners();
  }

  /*handleEvent(String event) {
    if (event == "home") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else if (event == "ss") {
      takeScreenshot();
    } else if (event == "tools") {
    } else if (event == "record") {
      record();
    }
  }*/

  /*record() {}

  takeScreenshot() {}*/

  getSize(String directoryPath) async {
    formattedSize = await getFormattedSize(directoryPath);
    notifyListeners();
  }

  void getStorageInfo() async {
    try {
      freeSpace = await DiskSpace.getFreeDiskSpace ?? 0;
      totalSpace = await DiskSpace.getTotalDiskSpace ?? 0;
      String totalS = formatMb(totalSpace.toInt());
      int remainSpace = totalSpace.toInt() - freeSpace.toInt();
      totalStorage = "${formatMb(remainSpace)}/$totalS";
    } catch (e) {
      Fluttertoast.showToast(msg: "something went wrong");
    }
    notifyListeners();
    return;
  }

  void changeIndex(int ind) {
    index = ind;
    notifyListeners();
  }
}
