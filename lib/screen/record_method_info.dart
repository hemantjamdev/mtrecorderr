import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mtrecorder/provider/permission_provider.dart';
import 'package:mtrecorder/screen/allow_permission.dart';
import 'package:mtrecorder/screen/homepage.dart';
import 'package:mtrecorder/utils/app_colors.dart';
import 'package:mtrecorder/utils/strings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../utils/shared_prefs.dart';

class RecordMethodInfo extends StatelessWidget {
  const RecordMethodInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "How to start/stop recording ?",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(height: 20),
                CustomContainer(
                  method: 'Method A',
                  operateWith: 'MTRecorder App',
                  asset: Strings.m1,
                ),
                SizedBox(height: 26),
                CustomContainer(
                  method: 'Method B',
                  operateWith: 'the floating icon',
                  asset: Strings.m2,
                ),
                SizedBox(height: 26),
                CustomContainer(
                  method: 'Method C',
                  operateWith: 'the notification panel',
                  asset: Strings.m3,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Consumer<PermissionProvider>(
          builder: (context, PermissionProvider provider, child) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: CupertinoButton.filled(
                borderRadius: BorderRadius.circular(20),
                onPressed: () {
                  /* if (provider.storage.isGranted) {
                    provider.getExternalDire();
                    provider.getStorageInfo();
                    provider.getAllMP4VideosFromLocation();
                  }*/

                  /// TODO
                  SharePrefs.setValue("method_info", true);
                  Future.delayed(const Duration(milliseconds: 10));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => provider.storage.isGranted
                          ? const HomePage()
                          : const AllowPermission(),
                    ),
                  );
                },
                child: const Text("GOT IT")));
      }),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String method;
  final String operateWith;
  final String asset;

  const CustomContainer(
      {super.key,
      required this.method,
      required this.operateWith,
      required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
          color: AppColors.backgroundSwatch,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Text(
              method,
              style: const TextStyle(color: AppColors.white, letterSpacing: 1),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Operate within $operateWith.",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 18),
          Center(child: SvgPicture.asset(asset)),
        ],
      ),
    );
  }
}
