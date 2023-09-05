import 'dart:io';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

show() async {
  if(!Platform.isAndroid)return;
  await FlutterOverlayWindow.showOverlay(
    enableDrag: true,
    height: 200,
    width: 200,
  );
}
