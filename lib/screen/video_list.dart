import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtrecorder/model/model.dart';
import 'package:mtrecorder/screen/video_player.dart';
import 'package:mtrecorder/utils/app_colors.dart';
import 'package:mtrecorder/utils/share.dart';
import 'package:mtrecorder/widgets/delete_selected.dart';
import 'package:mtrecorder/widgets/thumb_logo.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../provider/ad_provider.dart';
import '../provider/recording_provider.dart';
import '../utils/formate_duration.dart';
import '../utils/storage_convert.dart';
import '../utils/strings.dart';
import '../widgets/image_button.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 100), () {
      Provider.of<RecordingProvider>(context, listen: false)
          .getAllMP4VideosFromLocation();
    });

    return Consumer<RecordingProvider>(
      builder: (context, RecordingProvider provider, child) {
        return Scaffold(
          body: Stack(
            children: [
              provider.videoList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 200),
                          SvgPicture.asset(Strings.noVideos),
                          const SizedBox(height: 10),
                          const Text(
                            "There is no Video",
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          AdProvider.showFullAd()
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        provider.selectedList.isNotEmpty
                            ? selectedDelete(provider.deleteSelectedVideos,
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
                                        Text(
                                          provider.videoDirectory != null
                                              ? "${provider.videoDirectory!.path}"
                                              : "",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          "${provider.formattedSize}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: provider.videoList.length,
                            itemBuilder: (context, int index) {
                              VideoModel video = provider.videoList[index];
                              return GestureDetector(
                                onLongPress: () {
                                  provider.selectedList.isEmpty
                                      ? provider.addRemoveSelectedList(
                                          provider.videoList[index])
                                      : null;
                                },
                                onTap: () {
                                  if (provider.selectedList.isEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VideoPlayerPage(videoModel: video),
                                      ),
                                    );
                                  } else if (provider.selectedList.isNotEmpty) {
                                    provider.addRemoveSelectedList(
                                        provider.videoList[index]);
                                  }
                                },
                                child: SizedBox(
                                  width: 100.w,
                                  height: 15.h,
                                  child: Card(
                                    color: provider.selectedList
                                            .contains(provider.videoList[index])
                                        ? AppColors.backgroundSwatch
                                        : null,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundSwatch
                                                .withOpacity(0.5),
                                            image: const DecorationImage(
                                              fit: BoxFit.contain,
                                              image:
                                                  AssetImage(Strings.logoPng),
                                            ),
                                          ),
                                          margin: const EdgeInsets.all(4),
                                          height: 100.h,
                                          width: 40.w,
                                          child: Stack(
                                            children: [
                                              video.thumbnail != null
                                                  ? Center(
                                                      child: Image.memory(
                                                          video.thumbnail!),
                                                    )
                                                  : thumbLogo(),

                                              /// duration
                                              Positioned(
                                                bottom: 2,
                                                left: 2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  child: Text(
                                                    video.duration != null
                                                        ? getFormattedDuration(
                                                            video.duration!)
                                                        : "00:00:00",
                                                    style: const TextStyle(
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        path.basename(provider
                                                            .videoList[index]
                                                            .path),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: imageButton(
                                                        image: Strings.trash,
                                                        onTap: () {
                                                          provider
                                                              .deleteSingleItem(
                                                                  video);
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  video.isEdited
                                                      ? "Edited"
                                                      : "",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primarySwatch,
                                                      fontSize: 12),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: video.size != null
                                                          ? Text(
                                                              formatBytes(
                                                                  video.size!),
                                                            )
                                                          : const SizedBox(),
                                                    ),
                                                    /* Padding(
                                                      padding:
                                                          const EdgeInsets.all(8.0),
                                                      child: imageButton(
                                                        image: Strings.editVideo,
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  VideoEditor(
                                                                file: File(
                                                                    video.path),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),*/
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: imageButton(
                                                        image: Strings.share,
                                                        onTap: () {
                                                          shareVideo(
                                                            provider.videoList[
                                                                index],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              provider.videoList.isNotEmpty
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: AdProvider.showBannerAd())
                  : SizedBox()
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: "fab",
            label: Row(
              children: [
                imageButton(
                    image: provider.isRecording
                        ? Strings.stop
                        : Strings.recordOnOff),
                const SizedBox(width: 5),
                Text(provider.isRecording
                    ? formatIntDuration(provider.seconds)
                    : "Record")
              ],
            ),
            onPressed: () {
              provider.startStopRecording();
            },
          ),
        );
      },
    );
  }
}

/*
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mtrecorder/provider/recording_provider.dart';
import 'package:mtrecorder/screen/video_player.dart';
import 'package:mtrecorder/utils/app_colors.dart';
import 'package:mtrecorder/utils/formate_duration.dart';
import 'package:mtrecorder/utils/storage_convert.dart';
import 'package:mtrecorder/utils/strings.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../utils/share.dart';
import '../widgets/image_button.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      Provider.of<RecordingProvider>(context, listen: false)
          .getAllMP4VideosFromLocation();
    });
  }

  Widget logo = Container(
      padding: const EdgeInsets.all(20),
      height: 100.h,
      width: 100.w,
      color: AppColors.backgroundSwatch,
      child: Center(child: SvgPicture.asset(Strings.logo)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RecordingProvider>(
        builder: (context, RecordingProvider provider, child) {
          if (provider.videoList.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(Strings.noVideos),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "There is no Video",
                  style: TextStyle(color: AppColors.primaryColor),
                )
              ],
            ));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                provider.selectedList.isNotEmpty
                    ? Text(provider.selectedList.length.toString())
                    : Text(provider.videoDirectory != null
                        ? provider.videoDirectory!.path
                        : ""),
                provider.selectedList.isNotEmpty
                    ? const SizedBox()
                    : Text(provider.formattedSize ?? ""),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.videoList.length,
                    itemBuilder: (context, int index) {
                      File file = provider.videoList[index];

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
                                    VideoPlayerPage(videoFilePath: file.path),
                              ),
                            );
                          } else if (provider.selectedList.isNotEmpty) {
                            provider.addRemoveSelectedList(file);
                          }
                        },
                        child: SizedBox(
                          width: 100.w,
                          height: 15.h,
                          child: Card(
                            color: provider.selectedList.contains(file)
                                ? AppColors.backgroundSwatch
                                : null,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  height: 100.h,
                                  width: 40.w,
                                  child: Stack(
                                    children: [
                                      provider.thumbnailList.isEmpty
                                          ? const SizedBox()
                                          : (index >= 0 &&
                                                  index <
                                                      provider
                                                          .thumbnailList.length)
                                              ? (provider.thumbnailList[index]
                                                      .isNotEmpty
                                                  ? Center(
                                                      child: Image.memory(
                                                          provider.thumbnailList[
                                                              index]),
                                                    )
                                                  : logo)
                                              : logo,
                                      // thumbnail(file),
                                      Positioned(
                                          bottom: 2,
                                          left: 2,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: AppColors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              padding: const EdgeInsets.all(2),
                                              child: Text(
                                                provider.videoDataList.isEmpty
                                                    ? ""
                                                    : (index >= 0 &&
                                                            index <
                                                                provider
                                                                    .videoDataList
                                                                    .length)
                                                        ? provider
                                                                    .videoDataList[
                                                                        index]
                                                                    .duration !=
                                                                null
                                                            //? formatDoubleDuration(provider.videoDataList[index].duration??0):""
                                                            // ?"${provider.videoDataList[index].duration??0}": ""
                                                            ? getFormattedDuration(provider.videoDataList[index].duration)
                                                            : ""
                                                        : "",
                                                style: const TextStyle(
                                                    color: AppColors.white),
                                              )))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                path.basename(file.path),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: imageButton(
                                                  image: Strings.more,
                                                  onTap: () {}),
                                            )
                                          ],
                                        ),
                                        Text(
                                          provider.videoDataList.isEmpty
                                              ? ""
                                              : (index >= 0 &&
                                                      index <
                                                          provider.videoDataList
                                                              .length)
                                                  ? provider
                                                              .videoDataList[
                                                                  index]
                                                              .framerate !=
                                                          null
                                                      //? formatDoubleDuration(provider.videoDataList[index].duration??0):""
                                                      // ?"${provider.videoDataList[index].duration??0}": ""
                                                      ? provider.videoDataList[index].framerate.toString()
                                                      : ""
                                                  : "",
                                          style: const TextStyle(
                                              color: AppColors.black),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Text(formatBytes(
                                                    file.lengthSync()))),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: imageButton(
                                                  image: Strings.editVideo,
                                                  onTap: () {}),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: imageButton(
                                                  image: Strings.share,
                                                  onTap: () {
                                                    shareVideo(XFile(provider
                                                        .videoList[index]
                                                        .path));
                                                  }),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

*/
/*final videoInfo = FlutterVideoInfo();

  Future<VideoData?> getVideoMetadata(String videoPath) async {
    //  String videoFilePath = "your_video_file_path";
    return await videoInfo.getVideoInfo(videoPath);

    */ /*
 */
/* VideoPlayerController _videoController =
        VideoPlayerController.file(File(videoPath));

    try {
      await _videoController.initialize();
      final Duration duration = _videoController.value.duration;
      final double width = _videoController.value.size.width;
      final double height = _videoController.value.size.height;


      log("Video Resolution: ${width.toInt()}x${height.toInt()}");
      log("Video Duration (in seconds): ${duration.inSeconds}");
    } catch (e) {
      log("Error getting video metadata: $e");
    } finally {
      _videoController.dispose();
    }*/ /*
 */
/*
  }*/ /*


*/
/* Widget thumbnail(File file) {
    return FutureBuilder<Uint8List?>(
      future: getthumb(file.path),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return logo(); //
        } else if (snapshot.hasError) {
          return logo();
        } else if (snapshot.hasData) {
          if (snapshot.data != null) {
            return Center(
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.fill,
              ),
            ); //
          } else {
            return logo();
          }
        } else {
          return logo(); //
        }
      },
    );
  }*/
