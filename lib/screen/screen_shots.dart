import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtrecorder/provider/ad_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../provider/screenshot_provider.dart';
import '../utils/app_colors.dart';
import '../utils/strings.dart';
import '../widgets/delete_selected.dart';
import '../widgets/image_button.dart';

class ScreenShots extends StatefulWidget {
  const ScreenShots({Key? key}) : super(key: key);

  @override
  State<ScreenShots> createState() => _ScreenShotsState();
}

class _ScreenShotsState extends State<ScreenShots> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ScreenShotProvider>(context, listen: false)
        .getAllScreenshotsFromLocation();

    return Consumer<ScreenShotProvider>(
      builder: (context, ScreenShotProvider provider, child) {
        return
            /*Column(
            children: [
              FloatingActionButton(onPressed: (){provider.takeScreenshot();}),

        provider.screenshot == null
        ? Text("wait")
            : Container(
        height: 200,width: 200,
        child: Image.memory(provider
            .screenshot!),
        )    ],



            );*/
            Scaffold(
          body: Stack(
            children: [
              provider.imageList.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 200),
                        SvgPicture.asset(Strings.noScreenshots),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "There is no Images",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        AdProvider.showFullAd()
                      ],
                    ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        provider.selectedList.isNotEmpty
                            ? selectedDelete(provider.deleteSelectedImages,
                                provider.selectedList.length.toString())
                            : SizedBox(
                                width: 100.w,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(provider.imageDirectory != null
                                            ? provider.imageDirectory!.path
                                            : ""),
                                        Text(
                                          provider.imageDirectory != null
                                              ? "${provider.formattedSize}"
                                              : "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: provider.imageList.length,
                            itemBuilder: (context, int index) {
                              File file = provider.imageList[index];
                              return GestureDetector(
                                onLongPress: () {
                                  provider.selectedList.isEmpty
                                      ? provider.addRemoveSelectedList(file)
                                      : null;
                                },
                                onTap: () {
                                  if (provider.selectedList.isEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ImageView(file: file),
                                      ),
                                    );
                                  } else if (provider.selectedList.isNotEmpty) {
                                    provider.addRemoveSelectedList(file);
                                  }
                                },
                                child: Hero(
                                  tag: "image_${file.path}",
                                  child: Card(
                                      color:
                                          provider.selectedList.contains(file)
                                              ? AppColors.backgroundSwatch
                                              : null,
                                      child: Image.file(file,
                                          fit: BoxFit.contain)),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              provider.imageList.isNotEmpty
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: AdProvider.showBannerAd())
                  : const SizedBox()
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: "fab",
            label: Row(
              children: [
                imageButton(image: Strings.captureOnOff),
                const SizedBox(width: 5),
                const Text("Screenshot")
              ],
            ),
            onPressed: () async {
              PermissionStatus? storage = await Permission.storage.request();
              await Permission.manageExternalStorage.request();
              // if (storage.isGranted) {
              provider.takeScreenshot();
              // } else if (storage.isDenied) {
              //  Fluttertoast.showToast(msg: "storage permission is required");
              // } else if (storage.isLimited ||
              //   storage.isRestricted ||
              //   storage.isPermanentlyDenied) {
              // openAppSettings();
              //}
            },
          ),
        );
      },
    );
  }
}

class ImageView extends StatelessWidget {
  final File file;

  const ImageView({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(path.basename(file.path)),
      ),
      body: Hero(
        tag: "image_${file.path}",
        child: InteractiveViewer(
          child: Container(
            height: 100.h,
            width: 100.w,
            decoration:
                BoxDecoration(image: DecorationImage(image: FileImage(file))),
          ),
        ),
      ),
    );
  }
}
