import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

Widget imageButton({required String image, Function()? onTap}) {
  return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(image, height: 20.sp, width: 20.sp));
}
