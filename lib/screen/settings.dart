import 'package:flutter/material.dart';
import 'package:mtrecorder/utils/strings.dart';
import 'package:mtrecorder/widgets/info_dialog.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/app_colors.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "VIDEO",
              style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.mic_rounded),
            title: Text("Audio Setting"),
            trailing: Text(
              "Microphone(Auto)",
              style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.hd),
            title: Text("Video Setting"),
            trailing: Text(
              "Quality(Auto)",
              style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.screen_rotation),
            title: Text("Orientation"),
            trailing: Text(
              "Auto",
              style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.folder_rounded),
            title: Text("Video location"),
            subtitle: Text(
              "/storage/emulated/0/mtrecorder/videos",
              style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.folder_rounded),
            title: Text("Screenshot location"),
            subtitle: Text(
              "/storage/emulated/0/mtrecorder/screenshots",
              style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.timer),
            title: Text("Countdown before start"),
            trailing: Text(
              "3s(Auto)",
              style: TextStyle(fontSize: 14, color: AppColors.primaryColor),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.question_mark),
            title: Text("FAQ"),
          ),
          const ListTile(
            leading: Icon(Icons.menu_book_rounded),
            title: Text("Tutorial"),
          ),
          ListTile(
            onTap: () {
              Share.share("Hey! checkout this amazing app.");
            },
            leading: const Icon(Icons.share),
            title: const Text("SHARE"),
            subtitle: const Text("Share MT Recorder with your friends"),
          ),
          const ListTile(
            leading: Icon(Icons.policy),
            title: Text("Privacy Policy"),
          ),
          ListTile(
            onTap: () {
              info(context);
            },
            leading: const Icon(Icons.info_outline),
            title: const Text("Version ${Strings.appVersion}"),
          ),
        ],
      ),
    );
  }
}
