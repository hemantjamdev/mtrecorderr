import 'dart:convert';
import 'dart:typed_data';

class VideoModel {
  String id;
  Uint8List? thumbnail;
  String path;
  String name;
  int? size;
  double? duration;
  bool isEdited;

  VideoModel(
      {required this.id,
      required this.path,
      required this.name,
      this.thumbnail,
      this.duration,
      this.size,
      required this.isEdited});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      path: json['path'],
      name: json['name'],
      thumbnail: json['thumbnail'] != null
          ? Uint8List.fromList(jsonDecode(json['thumbnail']).cast<int>())
          : null,
      size: json['size'],
      duration: json['duration'],
      isEdited: json['isEdited'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'thumbnail': thumbnail != null ? jsonEncode(thumbnail!.toList()) : null,
      'size': size,
      'duration': duration,
      'isEdited': isEdited,
    };
  }
}
