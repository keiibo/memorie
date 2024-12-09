import 'dart:io';

import 'package:flutter/foundation.dart';

String getAdBannerUnitId() {
  String bannerUnitId = "";
  if (Platform.isAndroid) {
    // Android のとき
    bannerUnitId = kDebugMode
        ? "ca-app-pub-3940256099942544/6300978111" // Androidのデモ用バナー広告ID
        : "ca-app-pub-9468198082482711~9309518039";
  } else if (Platform.isIOS) {
    // iOSのとき
    bannerUnitId = kDebugMode
        ? "ca-app-pub-3940256099942544/2934735716" // iOSのデモ用バナー広告ID
        : "ca-app-pub-9468198082482711/4009261333";
  }
  return bannerUnitId;
}

String getAdInterstitialUnitId() {
  String interstitialUnitId = "";

  if (Platform.isAndroid) {
    // Android のとき
    interstitialUnitId = kDebugMode
        ? "ca-app-pub-9468198082482711/4821175355" // Androidのデモ用インタースティシャル広告ID
        : "ca-app-pub-9468198082482711~9309518039";
  } else if (Platform.isIOS) {
    // iOSのとき
    interstitialUnitId = kDebugMode
        ? "ca-app-pub-3940256099942544/4411468910" // iOSのデモ用インタースティシャル広告ID
        : "ca-app-pub-9468198082482711~7421892736";
  }
  return interstitialUnitId;
}
