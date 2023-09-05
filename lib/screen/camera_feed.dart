import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mtrecorder/provider/camera_feed_provider.dart';
import 'package:mtrecorder/provider/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';

class CameraFeed extends StatefulWidget {
  const CameraFeed({Key? key}) : super(key: key);

  @override
  State<CameraFeed> createState() => _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  @override
  void initState() {
    Provider.of<CameraFeedProvider>(context, listen: false).initializeCamera();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraFeedProvider>(
      builder: (context, CameraFeedProvider provider, child) {
        if (provider.controller == null ||
            !provider.controller!.value.isInitialized) {
          return const SizedBox(
            height: 10,
            width: 10,
          );
        }
        return Positioned(
          left: provider.containerOffset.dx,
          top: provider.containerOffset.dy,
          child: GestureDetector(
            onTap: () {
              provider.toggleControls();
            },
            onPanStart: (details) {
              provider.onPanStart(details);
            },
            onPanUpdate: (details) {
              provider.onPanUpdate(details);
            },
            child: Container(
              width: provider.containerWidth + provider.resizeDelta.dx,
              height: provider.containerHeight + provider.resizeDelta.dy,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black),
              ),
              child: Stack(
                children: [
                  SizedBox(
                      height: 99.h,
                      width: 99.w,
                      child: CameraPreview(provider.controller!)),
                  provider.showControls
                      ? Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Consumer<HomeProvider>(builder:
                                  (context, HomeProvider homeProvider, child) {
                                return CircleAvatar(
                                  backgroundColor:
                                      AppColors.primaryColor.withOpacity(0.5),
                                  child: GestureDetector(
                                    onTap: homeProvider.toggleFeed,
                                    child: const Icon(Icons.close,
                                        color: Colors.white),
                                  ),
                                );
                              }),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        AppColors.primaryColor.withOpacity(0.5),
                                    child: GestureDetector(
                                      onTap: provider.toggleCamera,
                                      child: const Icon(
                                          Icons.cameraswitch_sharp,
                                          color: Colors.white),
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor:
                                        AppColors.primaryColor.withOpacity(0.5),
                                    child: GestureDetector(
                                      onPanUpdate: (details) {
                                        provider.resize(details);
                                      },
                                      child: const Icon(Icons.aspect_ratio,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
