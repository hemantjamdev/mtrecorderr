import 'package:flutter/material.dart';
import 'package:mtrecorder/screen/recycle_bin.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';
import '../utils/storage_convert.dart';

class StorageDetails extends StatelessWidget {
  final double freeSpace;
  final double totalSpace;
  final double trash;

  const StorageDetails(
      {Key? key,
      required this.freeSpace,
      required this.totalSpace,
      required this.trash})
      : super(key: key);

  Widget details(
      {required Color color,
      required String text,
      required String space,
      Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 8.sp,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
          GestureDetector(
              onTap: onTap, child: Text("$space${onTap != null ? ">" : ""}"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: 30.sp,
                width: 30.sp,
                child: freeSpace != 0 && totalSpace != 00
                    ? CircularProgressIndicator(
                        value: (totalSpace - freeSpace) / totalSpace,
                        strokeWidth: 10.sp,
                        backgroundColor: Colors.grey,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor),
                      )
                    : const Icon(
                        Icons.info,
                        color: AppColors.primaryColor,
                      ),
              ),
              const SizedBox(width: 30),
              Text(
                formatMb((totalSpace - freeSpace).toInt()),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              Text(" of ${formatMb(totalSpace.toInt())} Used"),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
            child: Text("Storage details"),
          ),
          details(
              color: Colors.grey,
              text: "Remain",
              space: formatMb(freeSpace.toInt())),
          details(
              color: Colors.deepOrange,
              text: "Used",
              space: formatMb(totalSpace.toInt())),
          details(
              color: Colors.amber,
              text: "Trash",
              space: formatMb(trash.toInt()),
             /* onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const RecycleBin()));
              }*/),
        ],
      ),
    );
  }
}
