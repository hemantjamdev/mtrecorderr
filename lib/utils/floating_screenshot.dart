import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mtrecorder/utils/strings.dart';

class FloatingScreenshot {
  static const _mChannel = MethodChannel(Strings.methodChannel);

  static Future<Uint8List?> takeScreenshot() async {
    Uint8List? imageBytes;
    try {
      if(Platform.isAndroid){
       _mChannel.invokeMethod('takeScreenshot');}
     /* var image = await _mChannel.invokeMethod('takeScreenshot');
      final arrayView = image(Uint8List.fromList([1, 2, 3, 4]));
      imageBytes = arrayView.toUint8List();
      log("---type---${image.runtimeType.toString()}-----");*/
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error taking screenshot: ${e.message}");
      }
    }
    return imageBytes;
  }
}
