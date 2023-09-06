
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ImageList extends StatelessWidget {
  final List<File> images;
  final String title;

  const ImageList({Key? key, required this.images, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: images.isNotEmpty
          ? GridView.builder(
          shrinkWrap: true,
          itemCount: images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            log("data-----${images[index].lengthSync()}");
            log("data-----${images[index].path}");
            return Card(
                child: images[index].lengthSync() != 0
                    ? Image.file(images[index], fit: BoxFit.contain)
                    : const Icon(Icons.error_outline));
          })
          : const Center(
        child: Text(
          "Images not supported or empty",
          style: TextStyle(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
