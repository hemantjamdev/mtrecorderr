import 'dart:developer';

import 'package:share_plus/share_plus.dart';

import '../model/model.dart';

shareVideo(VideoModel videoModel) async {
  ShareResult result = await Share.shareXFiles([XFile(videoModel.path)]);
  log(result.status.toString());
}
