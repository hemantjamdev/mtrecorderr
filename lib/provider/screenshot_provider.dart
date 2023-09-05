import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mtrecorder/utils/floating_screenshot.dart';
import 'package:path/path.dart' as path_plugin;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/folder_size.dart';
import '../utils/get_external_dir.dart';

class ScreenShotProvider extends ChangeNotifier {
  ScreenShotProvider() {
    createDir();
  }

  Uint8List? screenshot;

  //String path = "";
  Directory? imageDirectory;
  List<File> imageList = <File>[];
  String? formattedSize;
  List<File> selectedList = <File>[];

  createDir() async {
    if (Platform.isAndroid) {
      imageDirectory = Directory("/storage/emulated/0/mtrecorder/screenshots/");
      if (imageDirectory != null) {
        if (!await imageDirectory!.exists()) {
          imageDirectory = await createExternalDir(imageDirectory!.path);
        }
      }
    } else if (Platform.isIOS) {
      imageDirectory = await getApplicationDocumentsDirectory();
    }
    notifyListeners();
  }

  void addRemoveSelectedList(File file) {
    if (selectedList.contains(file)) {
      selectedList.remove(file);
    } else {
      selectedList.add(file);
    }
    notifyListeners();
  }

  void deleteAllImages() {
    if (imageList.isNotEmpty) {
      for (File file in imageList) {
        file.delete(recursive: true);
      }
      imageList.clear();

      notifyListeners();
    }
  }

  void deleteSelectedImages() {
    if (selectedList.isNotEmpty) {
      for (File file in selectedList) {
        file.delete(recursive: true);
        imageList.remove(file);
      }
      selectedList.clear();
      notifyListeners();
    }
  }

  getSize(String directoryPath) async {
    formattedSize = await getFormattedSize(directoryPath);
    notifyListeners();
  }

  takeScreenshot() async {
    await FloatingScreenshot.takeScreenshot();
    /*  Uint8List? data = await FfNativeScreenshot().takeScreenshot();
    data != null ? screenshot = data : null;
    notifyListeners();*/
    /*Uint8List? image = await LocalNotifications.takeScreenshot();
    if (image == null) {
      return;
    } else {
      screenshot = image;
      notifyListeners();
      // log("image not null");
      // log(image!.lengthInBytes.toString());
      //saveImage(image);
    }*/
    //copyImageFile(screenshotPath);
    /*try {
      String? path = await ScreenshotPlus.takeShot();
      copyImageFile(path);
    } catch (e) {
      log(e.toString());
    }*/
  }

  saveImage(Uint8List uint8List) async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    String directoryPath = imageDirectory!.path;
    String filePath = '$directoryPath${"${DateTime.now()}.png"}';
//
    // Create the directory if it doesn't exist
    await Directory(directoryPath).create(recursive: true);

    // Write the Uint8List to the file
    File file = File(filePath);
    File newfile = await file.writeAsBytes(uint8List);
    // copyImageFile(newfile.path);
    log("path ----${newfile.path}");
  }

  /*Future<Directory?> createExternalDir() async {
    Directory newDir = Directory();
    if (!newDir.existsSync()) {
      Directory createdDir = await newDir.create(recursive: true);
      if (createdDir.existsSync()) {
        imageDirectory = createdDir;
      } else {
        imageDirectory = await getExternalStorageDirectory();
      }
    }
    imageDirectory = newDir;
    return imageDirectory;
  }*/

  Future<void> getAllScreenshotsFromLocation() async {
    if (!await imageDirectory!.exists()) return;
    List<FileSystemEntity> files = imageDirectory!.listSync(recursive: true);
    for (var file in files) {
      if (file is File) {
        // Check if the file is an image by its extension
        List<String> imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
        if (imageExtensions
            .contains(path_plugin.extension(file.path).toLowerCase())) {
          if (!imageList.any((image) => image.path == file.path)) {
            imageList.add(file);
          }
        }
      }
    }

    if (imageDirectory != null) {
      getSize(imageDirectory!.path);
    }
    notifyListeners();
    return;
  }

  Future<void> copyImageFile(String screenshotPath) async {
    imageDirectory =
        await createExternalDir("/storage/emulated/0/mtrecorder/screenshots/");
    if (imageDirectory == null) {
      Fluttertoast.showToast(msg: "something went wrong");
      return;
    }
    String baseNameWithExtension = path_plugin.basename(screenshotPath);
    String newImagePath = "${imageDirectory!.path}$baseNameWithExtension";
    File sourceFile = File(screenshotPath);
    File destinationFile = File(newImagePath);
    try {
      if (await sourceFile.exists()) {
        await sourceFile.copy(newImagePath);
        sourceFile.delete(recursive: true);
        if (await destinationFile.exists()) {
          log("image copied successfully.");
          Fluttertoast.showToast(msg: "image saved : $newImagePath");
          getAllScreenshotsFromLocation();
        } else {
          log("Error: image copy failed.");
        }
      } else {
        log("Error: image  not found.");
      }
    } catch (e) {
      log("Error while copying image: $e");
    }
    notifyListeners();
    return;
  }
}
