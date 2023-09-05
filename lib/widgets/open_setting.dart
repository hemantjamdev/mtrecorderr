import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mtrecorder/utils/app_colors.dart';
import 'package:mtrecorder/utils/strings.dart';

Future<bool> showOpenSetting(
    {required BuildContext context, required Widget text}) async {

  return await showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                Center(child: SvgPicture.asset(Strings.storagePopup)),
                const SizedBox(height: 12.0),
                text,
                const SizedBox(height: 12.0),
                const SizedBox(height: 8.0),
                const Text(
                  "1. Open settings",
                  style: TextStyle(fontSize: 16.0),
                ),
                const Text(
                  "2. Tap permissions",
                  style: TextStyle(fontSize: 16.0),
                ),
                const Text(
                  "3. Turn on permission",
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text(
                      "OPEN SETTINGS",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ) ??
      false;
}
