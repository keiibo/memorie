import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memorie/screens/home_screen.dart';
import 'package:memorie/services/stage_persistence_service.dart';

void main() async {
  if (kDebugMode) {
    print('デバッグモード');
  }
  // SharedPreferencesを使う前にFlutterのバインディングを初期化
  WidgetsFlutterBinding.ensureInitialized();
  // ステージのアンロック状態を読み込み
  await loadUnlockedStates();

  MobileAds.instance.initialize();

  // デバッグ用
  // ステージ1-1から1-4までをアンロック
  // unlockStageOneToFourStages();
  // 全てのステージをアンロック
  // unlockAllStages();

  // 画面を縦方向に固定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MemorieApp());
  });
}

class MemorieApp extends StatelessWidget {
  const MemorieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memorie',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
