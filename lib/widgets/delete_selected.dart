import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'image_button.dart';

Widget selectedDelete(VoidCallback callback, String length) {
  return SizedBox(
    width: 100.w,
    child: Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            length,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          imageButton(image: "assets/icons/trash.svg", onTap: callback
              /* if (provider.selectedList.isEmpty) {
                                        bool? value = await showConfirmationDialog(
                                            context, "Delete All Items");
                                        value != null && value
                                            ? provider.index == 1
                                            ? provider.deleteAllImages()
                                            : provider.deleteAllVideos()
                                            : null;
                                      } else if (provider.selectedList.isNotEmpty) {
                                        bool? value = await showConfirmationDialog(
                                            context, "Delete selected Items");
                                        value != null && value
                                            ? provider.index == 1
                                            ? screenshotProvider.deleteSelectedImages()
                                            : provider.deleteSelectedVideos()
                                            : null;
                                      }*/
              )
        ],
      ),
    )),
  );
}
