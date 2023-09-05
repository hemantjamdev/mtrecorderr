import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mtrecorder/utils/app_colors.dart';
import 'package:mtrecorder/utils/strings.dart';
import 'package:sizer/sizer.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<String> images = <String>[
    Strings.editVideoImage,
    Strings.editPhotos,
    Strings.fileTransfer,
    Strings.mergeVideos,
    Strings.otherApps,
    Strings.videoCompress
  ];
  List<String> textList = <String>[
    "EditVideo",
    "EditPhotos",
    "FileTransfer",
    "MergeVideos",
    "OtherApps",
    "VideoCompress"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          itemCount: images.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, int index) {
            return GestureDetector(
              onTap: () {
                Fluttertoast.showToast(msg: "coming soon");
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black.withOpacity(0.2))),
                margin: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(images[index]),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        textList[index],
                        style: TextStyle(
                            fontSize: 14.sp, color: AppColors.primaryColor),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
