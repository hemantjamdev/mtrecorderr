import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';
import '../utils/strings.dart';

Widget thumbLogo() {
  return Container(
    padding: const EdgeInsets.all(20),
    height: 100.h,
    width: 100.w,
    color: AppColors.backgroundSwatch,
    child: Center(child: SvgPicture.asset(Strings.logo)),
  );
}