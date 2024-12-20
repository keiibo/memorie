// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memorie/constants/colors.dart';
import 'package:memorie/screens/how_to_play_screen.dart';
import 'package:memorie/screens/main_stage_selection_screen.dart';
import 'package:memorie/services/audio_manager.dart';

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
    await AudioManager().playBGM('audio/bgm/yubiwa.mp3', volume: 0.5);
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
                          // 画面がじんわり暗くなるように遷移
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const StageSelectionScreen(),
                              transitionsBuilder:
                                  (context, animation1, animation2, child) {
                                return FadeTransition(
                                  opacity: animation1,
                                  child: child,
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: Colors.transparent),
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
                          // HowToPlay画面に遷移
                          // 画面がじんわり暗くなるように遷移
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const HowToPlayScreen(),
                              transitionsBuilder:
                                  (context, animation1, animation2, child) {
                                return FadeTransition(
                                  opacity: animation1,
                                  child: child,
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: Colors.transparent),
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
                      // TODO.リリース1.2で実装
                      // const SizedBox(height: 16),
                      // TextButton(
                      //   onPressed: () {
                      //     // 設定画面に遷移
                      //   },
                      // style: TextButton.styleFrom(
                      //  splashFactory: NoSplash.splashFactory,
                      //  overlayColor: Colors.transparent),
                      //   child: Text(
                      //     'Setting',
                      //     style: GoogleFonts.rockSalt(
                      //       textStyle: const TextStyle(
                      //         fontSize: 24,
                      //         color: AppColors.black,
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
