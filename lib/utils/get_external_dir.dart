import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<Directory?> getExternalDire(String path) async {
  if (Platform.isAndroid) {
    return await createExternalDir(path);
  }
  if (Platform.isIOS) {
    return await getApplicationDocumentsDirectory();
  }
  return null;
}

Future<Directory?> createExternalDir(String path) async {
  Directory newDir = Directory(path);
  if (!await newDir.exists()) {
    Directory createdDir = await newDir.create(recursive: true);
    if (await createdDir.exists()) {
      return newDir = createdDir;
    } else {
      return await getExternalStorageDirectory();
    }
  } else {
    log("dir exist ---- ${newDir.path}");
    return newDir;
  }
}
