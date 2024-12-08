import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memorie/screens/home_screen.dart';
import 'package:memorie/services/stage_persistence_service.dart';

void main() async {
  // SharedPreferencesを使う前にFlutterのバインディングを初期化
  WidgetsFlutterBinding.ensureInitialized();
  // ステージのアンロック状態を読み込み
  await loadUnlockedStates();

  // デバッグ用
  // unlockStageOneToFourStages();

  runApp(const MemorieApp());
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
