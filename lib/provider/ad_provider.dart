import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';

class AdProvider {
  static const String token =
      "POxgyeb4qC2sHBxUlFB_9RKP8VonSTxARaZcT3wtTSRm4tQBcwbiUk1FD3HarPt89rOhdasTqnvgIm9A87K2bt";
  static const String bannerId = "06d4f02711716f35";
  static const String mrecId = "5bf7b495e297f8ff";

  static initAd() async {
    if(Platform.isAndroid){
      await AppLovinMAX.initialize(token);
      AppLovinMAX.loadBanner(mrecId);
      AppLovinMAX.loadMRec(mrecId);
    }
  }

  static Widget showBannerAd() =>
      const MaxAdView(adUnitId: mrecId, adFormat: AdFormat.banner);

  static Widget showFullAd() =>
      const MaxAdView(adUnitId: mrecId, adFormat: AdFormat.mrec);
}
