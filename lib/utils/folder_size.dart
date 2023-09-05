import 'dart:io';

Future<String> getFormattedSize(String directoryPath) async {
  Directory directory = Directory(directoryPath);
  int sizeInBytes = await getDirectorySizeInBytes(directory);

  double sizeInKB = sizeInBytes / 1024;
  if (sizeInKB < 1) {
    return "${sizeInBytes.toStringAsFixed(2)} B";
  }

  double sizeInMB = sizeInKB / 1024;
  if (sizeInMB < 1) {
    return "${sizeInKB.toStringAsFixed(2)} KB";
  }

  double sizeInGB = sizeInMB / 1024;
  if (sizeInGB < 1) {
    return "${sizeInMB.toStringAsFixed(2)} MB";
  }

  return "${sizeInGB.toStringAsFixed(2)} GB";
}

Future<int> getDirectorySizeInBytes(Directory directory) async {
  int size = 0;
  if (await directory.exists()) {
    await for (FileSystemEntity entity
        in directory.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        size += await entity.length();
      }
    }
  }
  return size;
}
