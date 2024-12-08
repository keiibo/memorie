// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memorie/constants/colors.dart';
import 'package:memorie/screens/main_stage_selection_screen.dart';
import 'package:memorie/services/audio_manager.dart'; // 追加

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initBGM();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AudioManager().dispose(); // AudioManagerを解放
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      AudioManager().pauseBGM();
    } else if (state == AppLifecycleState.resumed) {
      AudioManager().resumeBGM();
    }
  }

  Future<void> _initBGM() async {
    await AudioManager().playBGM('audio/yubiwa.mp3', volume: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/backgrounds/bg.png'),
              fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                // 200の空白
                const SizedBox(height: 200),
                Text(
                  'Memorie',
                  style: GoogleFonts.rockSalt(
                    textStyle: const TextStyle(
                      fontSize: 48,
                      color: AppColors.black,
                    ),
                  ),
                ),
                // 120の空白
                const SizedBox(height: 120),
                // ボタンコンテナ
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          // ステージ選択画面に遷移
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const StageSelectionScreen()),
                          );
                        },
                        child: Text(
                          'Start',
                          style: GoogleFonts.rockSalt(
                            textStyle: const TextStyle(
                              fontSize: 24,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          // 遊び方画面に遷移
                          print('遊び方');
                          // ここに遊び方画面へのナビゲーションを追加することができます
                        },
                        child: Text(
                          'How to play',
                          style: GoogleFonts.rockSalt(
                            textStyle: const TextStyle(
                              fontSize: 24,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
