/*
import 'package:flutter/material.dart';
import 'package:mtrecorder/model.dart';
import 'package:mtrecorder/screen/video_player.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../provider/recording_provider.dart';

class RecycleBin extends StatefulWidget {
  const RecycleBin({Key? key}) : super(key: key);

  @override
  State<RecycleBin> createState() => _RecycleBinState();
}

class _RecycleBinState extends State<RecycleBin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trash"),
      ),
      body: Consumer<RecordingProvider>(
          builder: (context, RecordingProvider provider, child) {
        return Center(
          child: provider.videoList.isEmpty
              ? const Text("your videos will be listed here !")
              : GridView.builder(
                  itemCount: provider.videoList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, int index) {
                    VideoModel video = provider.videoList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayerPage(videoModel: video),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: video.thumbnail == null
                                        ? const SizedBox()
                                        : Image.memory(video.thumbnail!),
                                  ),
                                  Text(path.basename(video.path),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ),
                          Center(
                              child: Icon(
                            Icons.play_circle,
                            size: 50,
                            color: Colors.grey.withOpacity(0.5),
                          ))
                        ],
                      ),
                    );
                  },
                ),
        );
      }),
    );
  }
}
*/
