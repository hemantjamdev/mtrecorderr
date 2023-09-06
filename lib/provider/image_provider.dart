import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageListProvider extends ChangeNotifier {
  ImageListProvider() {
    //getAllImagesFromDevice();
  }

  Set<String> folderNames = <String>{};
  List<File> images = <File>[];
  List<ImageModel> modelList = [];
  int totalImages = 0;

  Future<PermissionState> getPermission() async {
    return await PhotoManager.requestPermissionExtend();
  }

  getAllFolderList() async {
    final PermissionState ps = await getPermission();
    if (ps.isAuth) {
      await Permission.manageExternalStorage.request();
      List<AssetEntity> entities = await PhotoManager.getAssetListRange(
          start: 0, end: 5000, type: RequestType.image);
      totalImages = entities.length;
      log(entities.first.title.toString());
      for (var element in entities) {
        String folderName = path.basename(element.relativePath!);
        if (!folderNames.contains(folderName)) {
          folderNames.add(folderName);
          ImageModel model =
              ImageModel(folderName: element.relativePath!, images: {});
          modelList.add(model);
        }
      }

      for (var model in modelList) {
        for (var entity in entities) {
          if (model.folderName == entity.relativePath) {
            File? file = await entity.file;
            if (file != null) {
              if (model.images != null &&
                  !model.images!.any((element) => element == file) &&
                  !model.images!.any((element) => element.path == file.path)) {
                if (file.path.endsWith('.png') ||
                    file.path.endsWith('.jpg') ||
                    file.path.endsWith("'.jpeg'")) {
                  model.images?.add(file);
                }
              }
            }
          }
          notifyListeners();
        }
      }
    } else {
      Fluttertoast.showToast(msg: "permission required");
    }
    notifyListeners();
  }

  getAllImagesFromDevice(String targetFolderName) async {
    List<AssetEntity> entities = await PhotoManager.getAssetListRange(
        start: 0, end: 5000, type: RequestType.image);
    List<AssetEntity> filteredEntities = entities.where((entity) {
      String folderName = entity.relativePath!;
      return folderName == targetFolderName;
    }).toList();

    if (filteredEntities.isNotEmpty) {
      ImageModel? model = modelList.firstWhere(
        (element) => element.folderName == targetFolderName,
        orElse: () {
          ImageModel newModel =
              ImageModel(folderName: targetFolderName, images: {});
          modelList.add(newModel);
          return newModel;
        },
      );

      for (var entity in filteredEntities) {
        File? entityFile = await entity.file;
        if (entityFile != null) {
          if (model.images != null &&
              !model.images!
                  .any((element) => element.path == entityFile.path)) {
            model.images?.add(entityFile);
          }
        }
      }
    }

    notifyListeners();
  }

/*getAllImagesFromDevice(String targetFolderName) async {
    List<AssetEntity> entities = await PhotoManager.getAssetListRange(
        start: 0, end: 5000, type: RequestType.image);

    for (var entity in entities) {
      if (entity.relativePath != null &&
          path.basename(entity.relativePath!) == targetFolderName) {
        File? entityFile = await entity.file;
        // Declare the model outside the loop
        ImageModel? model;

        // Find the corresponding model in modelList
        for (var element in modelList) {
          if (element.folderName == path.basename(entityFile!.path)) {
            // Create a new ImageModel with the image and folder name
            model = ImageModel(
                folderName: element.folderName, images: [entityFile]);
            break; // Exit the loop once the model is found
          }
        }

        // Add the model to modelList if it was created
        if (model != null) {
          modelList.add(model);
        }
      }
    }
    notifyListeners();
  }*/
}

class ImageModel {
  String folderName;
  Set<File>? images;

  ImageModel({required this.folderName, this.images});

  // Convert ImageModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'folderName': folderName,
      'images': images?.map((file) => file.path).toList(),
    };
  }

  // Create ImageModel from JSON
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    Set<File>? images;
    if (json['images'] != null) {
      images = Set<File>.from((json['images'] as List).map((imagePath) {
        return File(imagePath);
      }));
    }
    return ImageModel(
      folderName: json['folderName'],
      images: images,
    );
  }
}
