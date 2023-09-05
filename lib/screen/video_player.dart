import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mtrecorder/model/model.dart';
import 'package:mtrecorder/provider/recording_provider.dart';
import 'package:mtrecorder/screen/edit_video.dart';
import 'package:mtrecorder/utils/app_colors.dart';
import 'package:mtrecorder/utils/share.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../utils/formate_duration.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoPlayerPage({super.key, required this.videoModel});

  @override
  VideoPlayerPageState createState() => VideoPlayerPageState();
}

class VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isPlaying = false;
  bool showControl = true;

  void _togglePlayPause() {
    if (!isPlaying) {
      controller.play();
    } else {
      controller.pause();
    }
    isPlaying = !isPlaying;
    setState(() {});
  }

  Widget videoControls() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        header(),
        GestureDetector(
          onTap: () {
            _togglePlayPause();
          },
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Opacity(
                key: UniqueKey(),
                opacity: 0.5,
                child: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 100.sp,
                  // color: AppColors.black,
                ),
              ),
            ),
          ),
        ),
        Card(
          color: Colors.black.withOpacity(0.3),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 38.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(controller.value.position),
                  style: const TextStyle(color: AppColors.white),
                ),
                Expanded(
                  child: VideoProgressIndicator(
                    controller,
                    allowScrubbing: true,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    colors: const VideoProgressColors(
                      playedColor: AppColors.primaryColor,
                      bufferedColor: AppColors.grey,
                      backgroundColor: AppColors.white,
                    ),
                  ),
                ),
                Text(
                  '-${formatDuration(controller.value.duration - controller.value.position)}',
                  style: const TextStyle(color: AppColors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget header() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.black.withOpacity(0.5),
      title: Text(path.basename(widget.videoModel.path)),
      actions: [
        IconButton(
            color: AppColors.white,
            onPressed: () {
              shareVideo(widget.videoModel);
            },
            icon: const Icon(Icons.share_outlined)),
        Consumer<RecordingProvider>(
            builder: (context, RecordingProvider provider, child) {
          return IconButton(
              color: AppColors.white,
              onPressed: () {
                provider.deleteSingleItem(widget.videoModel);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete));
        }),
       /* IconButton(
            color: AppColors.white,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VideoEditor(file: File(widget.videoModel.path)),
                ),
              );
            },
            icon: const Icon(Icons.edit)),*/
      ],
    );
  }

  void _onPositionChanged() {
    if (controller.value.position == controller.value.duration) {
      // isPlaying = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(File(widget.videoModel.path));
    _initializeVideoPlayerFuture = controller.initialize();
    controller.addListener(_onPositionChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onPositionChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            showControl = !showControl;
          });
        },
        child: Stack(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return VideoPlayer(controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            SafeArea(
              child: showControl ? videoControls() : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
