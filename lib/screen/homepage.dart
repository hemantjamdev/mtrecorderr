import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mtrecorder/provider/home_provider.dart';
import 'package:mtrecorder/provider/notificatin_provider.dart';
import 'package:mtrecorder/provider/permission_provider.dart';
import 'package:mtrecorder/provider/recording_provider.dart';
import 'package:mtrecorder/provider/screenshot_provider.dart';
import 'package:mtrecorder/screen/camera_feed.dart';
import 'package:mtrecorder/screen/edit.dart';
import 'package:mtrecorder/screen/settings.dart';
import 'package:mtrecorder/screen/video_list.dart';
import 'package:mtrecorder/utils/check_android_version.dart';
import 'package:mtrecorder/utils/floating_record.dart';
import 'package:mtrecorder/utils/strings.dart';
import 'package:mtrecorder/widgets/delete_all.dart';
import 'package:mtrecorder/widgets/info_dialog.dart';
import 'package:mtrecorder/widgets/storage_details.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../widgets/image_button.dart';
import '../widgets/logo.dart';
import 'folder_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _controller;

  StreamSubscription<dynamic>? _subscription;
  final String bannerAdid = "06d4f02711716f35";

  /*bannerAd() async {
    AppLovinMAX.createBanner(bannerAdid, AdViewPosition.centered);
    AppLovinMAX.loadBanner(bannerAdid);
    AppLovinMAX.showBanner(bannerAdid);
  }*/

  void showNotification() async {
    if (!Platform.isAndroid) return;
    if (await checkAndroidVersion()) {
      PermissionStatus notification = await Permission.notification.request();
      if (notification.isGranted) {
        if (mounted) {
          Provider.of<NotificationProvider>(context, listen: false)
              .showNotification();
        }
      }
    } else {
      if (mounted) {
        Provider.of<NotificationProvider>(context, listen: false)
            .showNotification();
      }
    }
    startListeningNotification();
  }

  void startListeningNotification() {
    final notificationStream =
        Provider.of<NotificationProvider>(context, listen: false)
            .notificationStream;
    _subscription = notificationStream.listen((event) {
      handleNotificationListen(event.toString());
    });
  }

  void handleNotificationListen(String event) {
    if (event == "record") {
      Provider.of<RecordingProvider>(context, listen: false)
          .startStopRecording();
    } else if (event == "ss") {
      Provider.of<ScreenShotProvider>(context, listen: false).takeScreenshot();
    } else if (event == "tools") {
      Provider.of<HomeProvider>(context, listen: false).changeIndex(2);
    } else if (event == "home") {
      Provider.of<HomeProvider>(context, listen: false).changeIndex(0);
    }
  }

  List<Widget> screens = const [
    VideoList(),
    FolderList(),
    EditPage(),
    Settings(),
  ];

  void handleOverlayListen(Object? message) {
    if (message != null) {
      Provider.of<RecordingProvider>(context, listen: false)
          .startStopRecording();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    Provider.of<HomeProvider>(context, listen: false).getStorageInfo();
    showNotification();
    FloatingRecord.initFloating((message) => handleOverlayListen(message));
    // bannerAd();
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription = null;
    _subscription?.cancel();
    FloatingRecord.receivePort.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          /*IconButton(
              onPressed: showNotification,
              icon: const Icon(Icons.notifications)),*/
          Consumer<HomeProvider>(
              builder: (context, HomeProvider provider, child) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: deleteAll(
                    context,
                    provider.index == 1
                        ? Provider.of<ScreenShotProvider>(context)
                            .deleteAllImages
                        : Provider.of<RecordingProvider>(context)
                            .deleteAllVideos));
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: imageButton(
                image: Strings.info,
                onTap: () {
                  info(context);
                }),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: logo(),
      ),
      body: SafeArea(
        child: Consumer<HomeProvider>(
            builder: (context, HomeProvider provider, child) {
          return Stack(
            children: [
              Column(
                children: [
                 Platform.isAndroid? provider.index < 2?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  showDragHandle: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15))),
                                  context: context,
                                  builder: (context) => StorageDetails(
                                        freeSpace: provider.freeSpace,
                                        totalSpace: provider.totalSpace,
                                        trash: 0.0,
                                      ));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: AppColors.backgroundSwatch,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: provider.freeSpace != 0 &&
                                              provider.totalSpace != 00
                                          ? CircularProgressIndicator(
                                              value: (provider.totalSpace -
                                                      provider.freeSpace) /
                                                  provider.totalSpace,
                                              strokeWidth: 6,
                                              backgroundColor: AppColors.grey,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                          Color>(
                                                      AppColors.primaryColor),
                                            )
                                          : const Icon(
                                              Icons.error_outline,
                                              color: AppColors.primaryColor,
                                            ),
                                    ),
                                  ),
                                  Text(provider.totalStorage),
                                ],
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          CircleAvatar(
                            backgroundColor: provider.showFeed
                                ? AppColors.primaryColor.withOpacity(0.5)
                                : AppColors.backgroundSwatch,
                            child: imageButton(
                                image: Strings.webcam,
                                onTap: () async {
                                  PermissionStatus? camera =
                                      await Provider.of<PermissionProvider>(
                                              context,
                                              listen: false)
                                          .requestCameraPermission();
                                  if (camera == null) return;
                                  if (camera.isGranted) {
                                    log("on tappedd-----");
                                    // provider.toggleCameraOverlay(context);
                                    provider.toggleFeed();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "permission required for camera");
                                  }
                                }),
                          ),
                          const SizedBox(width: 10),

                          /// screenshot
                          Consumer<ScreenShotProvider>(builder: (context,
                              ScreenShotProvider screenshotProvider, child) {
                            return CircleAvatar(
                              backgroundColor: AppColors.backgroundSwatch,
                              child: imageButton(
                                  image: Strings.screenshotToggle,
                                  onTap: () {
                                    //LocalNotifications.takeScreenshot();
                                    // handleOverlay();
                                    screenshotProvider.takeScreenshot();
                                  }),
                            );
                          }),

                          /// paint
                          /*   CircleAvatar(
                                    backgroundColor: AppColors.backgroundSwatch,
                                    child: imageButton(
                                        image: Strings.brush,
                                        onTap: () {
                                          handleNotification();
                                          //  Notification  no =Notification();
                                          */ /*LocalNotifications
                                              .showNotificationWithButtons();*/ /*
                                        }),
                                  ),*/
                          const SizedBox(width: 10),

                          CircleAvatar(
                            backgroundColor: provider.overlayActive
                                ? AppColors.primaryColor.withOpacity(0.7)
                                : AppColors.backgroundSwatch,
                            child: imageButton(
                                image: Strings.recordingToggle,
                                onTap: () => provider.toggleOverlay()),
                          ),
                        ],
                      ),
                    )
                  :
                    const SizedBox():const SizedBox(),
                  Expanded(child: screens[provider.index]),
                ],
              ),
              provider.showFeed ? const CameraFeed() : const SizedBox.shrink(),

              /// counter
              /* Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return ScaleTransition(
                          scale: _controller,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.0),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              count.toString(),
                              style: TextStyle(
                                  fontSize: 100.sp, color: AppColors.primaryColor),
                            ),
                          ),
                        ); */ /*FadeTransition(
                          opacity: _controller,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.0),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              count > 0 ? count.toString() : '',
                              style: const TextStyle(fontSize: 80, color: AppColors.primaryColor),
                            ),
                          ),
                        );*/ /*
                      },
                    ),
                  ),*/
            ],
          );
        }),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 10.0,
              spreadRadius: 5.0,
              offset: const Offset(-3.0, -3.0),
            )
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: AnimatedContainer(
          curve: Curves.bounceOut,
          color: AppColors.white,
          duration: const Duration(milliseconds: 50),
          child: Consumer<HomeProvider>(
              builder: (context, HomeProvider provider, child) {
            return BottomNavigationBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              currentIndex: provider.index,
              onTap: provider.changeIndex,
              items: [
                buildBottomNavigationBarItem(
                    activeIcon: Strings.videoSelected,
                    icon: Strings.video,
                    label: 'VIDEO'),
                buildBottomNavigationBarItem(
                    activeIcon: Strings.cameraSelected,
                    icon: Strings.camera,
                    label: 'PHOTO'),
                buildBottomNavigationBarItem(
                    activeIcon: Strings.editSelected,
                    icon: Strings.edit,
                    label: 'EDIT'),
                buildBottomNavigationBarItem(
                    activeIcon: Strings.settingSelected,
                    icon: Strings.setting,
                    label: 'SETTINGS'),
              ],
            );
          }),
        ),
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      {required String activeIcon,
      required String icon,
      required String label}) {
    return BottomNavigationBarItem(
      activeIcon: imageButton(image: activeIcon),
      icon: imageButton(image: icon),
      label: label,
    );
  }
}
