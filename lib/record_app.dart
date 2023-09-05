import 'package:flutter/material.dart';
import 'package:mtrecorder/provider/camera_feed_provider.dart';
import 'package:mtrecorder/provider/home_provider.dart';
import 'package:mtrecorder/provider/notificatin_provider.dart';
import 'package:mtrecorder/provider/permission_provider.dart';
import 'package:mtrecorder/provider/recording_provider.dart';
import 'package:mtrecorder/provider/screenshot_provider.dart';
import 'package:mtrecorder/screen/splash.dart';
import 'package:mtrecorder/utils/app_colors.dart';
import 'package:mtrecorder/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class RecordApp extends StatelessWidget {
  const RecordApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<RecordingProvider>(
              create: (context) => RecordingProvider()),
          ChangeNotifierProvider<ScreenShotProvider>(
              create: (context) => ScreenShotProvider()),
          ChangeNotifierProvider<PermissionProvider>(
              create: (context) => PermissionProvider()),
          ChangeNotifierProvider<HomeProvider>(
              create: (context) => HomeProvider()),
          ChangeNotifierProvider<NotificationProvider>(
              create: (context) => NotificationProvider()),
         /* ChangeNotifierProvider<FloatingProvider>(
              create: (context) => FloatingProvider()),*/
          ChangeNotifierProvider<CameraFeedProvider>(
              create: (context) => CameraFeedProvider()),
        ],
        child: MaterialApp(
          title: Strings.appTitle,
          theme: ThemeData(
              appBarTheme: const AppBarTheme(
                actionsIconTheme: IconThemeData(
                  color: AppColors.black,
                  size: 26,
                ),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: AppColors.primaryColor,
                unselectedItemColor: AppColors.black,
                selectedIconTheme: IconThemeData(color: AppColors.primaryColor),
                backgroundColor: AppColors.primaryColor,
              ),
              unselectedWidgetColor: AppColors.black,
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white),
              useMaterial3: false,
              primarySwatch: AppColors.primarySwatch,
              primaryColor: AppColors.primaryColor,
              tabBarTheme: const TabBarTheme(
                  indicatorColor: AppColors.primaryColor,
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: AppColors.black)),
          debugShowCheckedModeBanner: false,
          home: const Splash(),
        ),
      );
    });
  }
}
