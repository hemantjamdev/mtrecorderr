import 'package:flutter/material.dart';
import 'package:mtrecorder/utils/strings.dart';

import 'confirmation_dialog.dart';
import 'image_button.dart';

Widget deleteAll(BuildContext context, Function callback) {
  return imageButton(
      image: Strings.trash,
      onTap: () async {
        bool? value = await showConfirmationDialog(context);
        value != null && value ? callback() : null;
      });
}
