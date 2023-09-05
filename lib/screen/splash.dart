import 'package:flutter/material.dart';
import 'package:mtrecorder/screen/homepage.dart';
import 'package:mtrecorder/utils/shared_prefs.dart';
import 'package:mtrecorder/utils/strings.dart';
import 'package:sizer/sizer.dart';

import 'record_method_info.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  handleNavigate() async {
    bool value = await SharePrefs.getValue("method_info");
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              value ? const HomePage() : const RecordMethodInfo(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    handleNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Strings.splash),
              fit: BoxFit.cover,
            ),
          ),
          height: 100.h,
          width: 100.w,
        ),
      ),
    );
  }
}