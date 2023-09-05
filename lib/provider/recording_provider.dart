import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mtrecorder/model/model.dart';
import 'package:path/path.dart' as path_plugin;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../utils/folder_size.dart';
import '../utils/get_external_dir.dart';

Uuid uuid = const Uuid();

class RecordingProvider with ChangeNotifier {
  RecordingProvider() {
    createDir();
    listen();
  }

  listen() {
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameHome,
    );
    _receivePort.listen((message) {
      if (message != null) {
        startStopRecording();
      }
    });
  }

  static const String _kPortNameHome = 'UI';

  bool isRecording = false;
  Directory? videoDirectory;
  final List<VideoModel> videoList = <VideoModel>[];

  // final List<Uint8List> thumbnailList = <Uint8List>[];
  // final List<VideoData> videoDataList = <VideoData>[];
  Timer? timer;
  int seconds = 0;
  List<VideoModel> selectedList = <VideoModel>[];
  final videoInfo = FlutterVideoInfo();
  static const String _kPortNameOverlay = 'OVERLAY';
  SendPort? homePort;
  String? formattedSize;
  final _receivePort = ReceivePort();

  void deleteSingleItem(VideoModel model) {
    File file = File(model.path);
    file.delete();
    videoList.remove(model);
    notifyListeners();
  }

  void addRemoveSelectedList(VideoModel model) {
    if (selectedList.contains(model)) {
      selectedList.remove(model);
    } else {
      selectedList.add(model);
    }
    notifyListeners();
  }

  Future<void> startStopRecording() async {
    log("recording method call---->");
    PermissionStatus? microphone = await Permission.microphone.request();
    PermissionStatus? storage = Platform.isIOS
        ? await Permission.photos.request()
        : await Permission.storage.request();
    if (microphone.isGranted) {
      log("microphone granted---->");
      if (Platform.isAndroid) {
        homePort ??= IsolateNameServer.lookupPortByName(
          _kPortNameOverlay,
        );
        IsolateNameServer.registerPortWithName(
          _receivePort.sendPort,
          _kPortNameOverlay,
        );
      }
      /*if (Platform.isIOS) {
        Permission.photos.request();
      }*/
      if (isRecording) {
        log("recording stopped---->");
        String recordedVideoPath =
            await FlutterScreenRecording.stopRecordScreen;
        log("video path after stop -->${recordedVideoPath}");
        timer!.cancel();
        seconds = 0;
        isRecording = !isRecording;
        if (Platform.isAndroid) {
          homePort?.send(seconds);
          homePort?.send(isRecording);
        }

         copyVideoFile(recordedVideoPath);
      } else if (!isRecording) {
        log("recording start---->");
        try {
          log("dir path --${videoDirectory?.path}");
          log("try bloc ---->");
          String timeNow = DateTime.now().toLocal().toString();
          timeNow = timeNow.replaceAll(":", "_").trim();
          if (Platform.isIOS) {
            Permission.notification.request();
          }
          FlutterScreenRecording.globalForegroundService();
          /*
          FlutterScreenRecording
              .globalForegroundService*/ // Replace colons with underscores
          await FlutterScreenRecording.startRecordScreenAndAudio(timeNow,
              titleNotification: "Mt Recorder",
              messageNotification: "MtRecorder");
          timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            seconds = timer.tick;
            Platform.isAndroid ? homePort?.send(seconds) : null;
            notifyListeners();
          });
          isRecording = !isRecording;
          Platform.isAndroid ? homePort?.send(seconds) : null;
        } catch (e) {
          log("catch bloc ---->");

          Fluttertoast.showToast(msg: "Error starting recording.");
        }
      }
    } else {
      log("here is the issue---->");
      Fluttertoast.showToast(msg: " permissions are required. ");
    }
    notifyListeners();
  }

  Future<void> getAllMP4VideosFromLocation({bool edit = false}) async {
    log("show notification method  ---->");

    //if (!await videoDirectory!.exists()) return;
    List<FileSystemEntity> files = videoDirectory!.listSync(recursive: true);
    for (var file in files) {
      if (file is File) {
        if (!videoList.any((element) => element.path == file.path)) {
          String name = path_plugin.basename(file.path);
          String id = uuid.v4();
          VideoData? videoData;
          Uint8List? thumbnail;
          if (file.path.isNotEmpty) {
            videoData = await videoInfo.getVideoInfo(file.path);
            thumbnail = await VideoThumbnail.thumbnailData(
              video: file.path,
              imageFormat: ImageFormat.PNG,
              maxWidth: 128,
              quality: 25,
            );
          }

          VideoModel model = VideoModel(
              id: id,
              path: file.path,
              name: name,
              size: videoData?.filesize,
              duration: videoData?.duration,
              thumbnail: thumbnail,
              isEdited: edit);
          videoList.add(model);

          /* if (!videoList.any((video) => video.path == file.path)) {
          VideoModel model = VideoModel(id: id, path: path, name: name);
          videoList.add(file);
          //notifyListeners();
        }
        addThumbnail(file.path);
        getVideoMetadata(file.path);*/
        }
      }
      notifyListeners();
    }
    if (videoDirectory != null) {
      getSize(videoDirectory!.path);
    }
    notifyListeners();
  }

  createDir() async {
    if (Platform.isAndroid) {
      videoDirectory = Directory("/storage/emulated/0/mtrecorder/videos/");
    } else if (Platform.isIOS) {
      videoDirectory = await getApplicationDocumentsDirectory();
    }
    if (videoDirectory != null) {
      if (!await videoDirectory!.exists()) {
        videoDirectory = await createExternalDir(videoDirectory!.path);
      }
      notifyListeners();
    }
  }

  /* Future<void> getVideoMetadata(String videoPath) async {
    VideoData? videoData = await videoInfo.getVideoInfo(videoPath);
    if (videoData != null) {
      if (!videoDataList.any((element) => element == videoData)) {
        videoDataList.add(videoData);
      }
    }
    notifyListeners();
  }*/

/*
  Future<Uint8List?> getThumbnail(String path) async {
    Uint8List? t;
    t =
    return t;
  }
*/

  /* Future<void> addThumbnail(String path) async {
    try {
      Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
        video: path,
        imageFormat: ImageFormat.PNG,
        maxWidth: 128,
        quality: 25,
      );
      if (thumbnail != null && thumbnail.isNotEmpty) {
        if (!thumbnailList.contains(thumbnail)) {
          thumbnailList.add(thumbnail);
        }
      }
    } catch (e) {
      log("Error adding thumbnail: $e");
    }
    notifyListeners();
  }*/

  void deleteAllVideos() {
    if (videoList.isNotEmpty) {
      for (VideoModel path in videoList) {
        File file = File(path.path);
        file.delete(recursive: true);
      }
      videoList.clear();
      notifyListeners();
    }
  }

  getSize(String directoryPath) async {
    formattedSize = await getFormattedSize(directoryPath);
    notifyListeners();
  }

  void deleteSelectedVideos() {
    if (selectedList.isNotEmpty) {
      for (VideoModel model in selectedList) {
        videoList.remove(model);
        File file = File(model.path);
        file.delete(recursive: true);
      }
      selectedList.clear();
      notifyListeners();
    }
  }

  Future<void> copyVideoFile(String recordedVideoPath,
      {bool edit = false}) async {
    videoDirectory =
        await createExternalDir("/storage/emulated/0/mtrecorder/videos/");
    String baseNameWithExtension = path_plugin.basename(recordedVideoPath);
    String newVideoName = "${videoDirectory!.path}$baseNameWithExtension";
    File sourceFile = File(recordedVideoPath);
    File destinationFile = File(newVideoName);
    try {
      if (await sourceFile.exists()) {
        await sourceFile.copy(newVideoName);
        sourceFile.delete(recursive: true);

        if (await destinationFile.exists()) {
          getAllMP4VideosFromLocation(edit: edit);
        } else {
          Fluttertoast.showToast(msg: "Error: Video copy failed.");
        }
      } else {
        Fluttertoast.showToast(msg: "Error: Source video not found.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error while copying video: $e");
    }
    notifyListeners();
    return;
  }
}

/*
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path_plugin;
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../utils/folder_size.dart';
import '../utils/get_external_dir.dart';

class RecordingProvider with ChangeNotifier {
  RecordingProvider() {
    createDir();
    listen();
  }

  listen() {
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameHome,
    );
    _receivePort.listen((message) {
      if (message != null) {
        startStopRecording();
      }
    });
  }

  static const String _kPortNameHome = 'UI';

  bool isRecording = false;
  Directory? videoDirectory;
  final List<File> videoList = <File>[];
  final List<Uint8List> thumbnailList = <Uint8List>[];
  final List<VideoData> videoDataList = <VideoData>[];
  Timer? timer;
  int seconds = 0;
  List<File> selectedList = <File>[];
  final videoInfo = FlutterVideoInfo();
  static const String _kPortNameOverlay = 'OVERLAY';
  SendPort? homePort;
  String? formattedSize;
  final _receivePort = ReceivePort();

  void deleteSingleItem(File file) {
    file.delete();
    videoList.remove(file);
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

  Future<void> startStopRecording() async {
    PermissionStatus? microphone = await Permission.microphone.request();
    PermissionStatus? storage = await Permission.storage.request();
    if (microphone.isGranted && storage.isGranted) {
      homePort ??= IsolateNameServer.lookupPortByName(
        _kPortNameOverlay,
      );
      IsolateNameServer.registerPortWithName(
        _receivePort.sendPort,
        _kPortNameOverlay,
      );

      if (isRecording) {
        String recordedVideoPath =
            await FlutterScreenRecording.stopRecordScreen;
        timer!.cancel();
        seconds = 0;
        isRecording = !isRecording;
        homePort?.send(isRecording);
        copyVideoFile(recordedVideoPath);
      } else if (!isRecording) {
        try {
          String timeNow = DateTime.now().toLocal().toString();
          timeNow = timeNow.replaceAll(":", "_");
          FlutterScreenRecording
              .globalForegroundService(); // Replace colons with underscores
          await FlutterScreenRecording.startRecordScreenAndAudio(timeNow,
              titleNotification: "Mt Recorder",
              messageNotification: "MtRecorder");
          timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            seconds = timer.tick;
            homePort?.send(seconds);
            notifyListeners();
          });
          isRecording = !isRecording;
          homePort?.send(isRecording);
        } catch (e) {
          Fluttertoast.showToast(msg: "Error starting recording.");
        }
      }
    } else {
      Fluttertoast.showToast(msg: " permissions are required. ");
    }
    notifyListeners();
  }

  Future<void> getAllMP4VideosFromLocation() async {
    if (!await videoDirectory!.exists()) return;
    List<FileSystemEntity> files = videoDirectory!.listSync(recursive: true);
    for (var file in files) {
      if (file is File) {
        if (!videoList.any((video) => video.path == file.path)) {
          videoList.add(file);
          //notifyListeners();
        }
        addThumbnail(file.path);
        getVideoMetadata(file.path);
      }
    }
    if (videoDirectory != null) {
      getSize(videoDirectory!.path);
    }
    notifyListeners();
  }

  createDir() async {
    videoDirectory = Directory("/storage/emulated/0/mtrecorder/videos/");
    if (videoDirectory != null) {
      if (!await videoDirectory!.exists()) {
        videoDirectory = await createExternalDir("");
      }
      notifyListeners();
    }
  }

  Future<void> getVideoMetadata(String videoPath) async {
    VideoData? videoData = await videoInfo.getVideoInfo(videoPath);
    if (videoData != null) {
      if (!videoDataList.any((element) => element == videoData)) {
        videoDataList.add(videoData);
      }
    }
    notifyListeners();
  }

  Future<Uint8List?> getThumbnail(String path) async {
    Uint8List? t;
    t = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 128,
      quality: 25,
    );
    return t;
  }

  Future<void> addThumbnail(String path) async {
    try {
      Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
        video: path,
        imageFormat: ImageFormat.PNG,
        maxWidth: 128,
        quality: 25,
      );
      if (thumbnail != null && thumbnail.isNotEmpty) {
        if (!thumbnailList.contains(thumbnail)) {
          thumbnailList.add(thumbnail);
        }
      }
    } catch (e) {
      log("Error adding thumbnail: $e");
    }
    notifyListeners();
  }

  void deleteAllVideos() {
    if (videoList.isNotEmpty) {
      for (File file in videoList) {
        file.delete(recursive: true);
      }
      videoList.clear();
      thumbnailList.clear();
      notifyListeners();
    }
  }

  getSize(String directoryPath) async {
    formattedSize = await getFormattedSize(directoryPath);
    notifyListeners();
  }

  void deleteSelectedVideos() {
    if (selectedList.isNotEmpty) {
      for (File file in selectedList) {
        videoList.remove(file);
        file.delete(recursive: true);
      }
      selectedList.clear();
      thumbnailList.clear();
      notifyListeners();
    }
  }

  Future<void> copyVideoFile(String recordedVideoPath) async {
    videoDirectory =
        await createExternalDir("/storage/emulated/0/mtrecorder/videos/");
    String baseNameWithExtension = path_plugin.basename(recordedVideoPath);
    String newVideoName = "${videoDirectory!.path}$baseNameWithExtension";
    File sourceFile = File(recordedVideoPath);
    File destinationFile = File(newVideoName);
    try {
      if (await sourceFile.exists()) {
        await sourceFile.copy(newVideoName);
        sourceFile.delete(recursive: true);

        if (await destinationFile.exists()) {
          getAllMP4VideosFromLocation();
        } else {
          Fluttertoast.showToast(msg: "Error: Video copy failed.");
        }
      } else {
        Fluttertoast.showToast(msg: "Error: Source video not found.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error while copying video: $e");
    }
    notifyListeners();
    return;
  }
}
*/
