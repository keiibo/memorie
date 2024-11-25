import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memorie/constants/colors.dart';
import 'package:memorie/screens/main_stage_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                                        StageSelectionScreen()),
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
                            )),
                        const SizedBox(height: 16),
                        TextButton(
                            onPressed: () {
                              // 遊び方画面に遷移
                              print('遊び方');
                            },
                            child: Text(
                              'How to play',
                              style: GoogleFonts.rockSalt(
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  color: AppColors.black,
                                ),
                              ),
                            ))
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
