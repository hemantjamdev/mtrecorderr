import 'package:flutter/material.dart';
import 'package:mtrecorder/utils/app_colors.dart';
import 'package:mtrecorder/utils/strings.dart';
import 'package:mtrecorder/widgets/image_button.dart';

info(BuildContext context) {
  showAboutDialog(
      context: context,
      applicationName: Strings.appTitle,
      applicationVersion: Strings.appVersion,
      applicationIcon: Container(
          padding: const EdgeInsets.all(10),
          color: AppColors.primarySwatch,
          child: imageButton(image: Strings.logo)));
}
