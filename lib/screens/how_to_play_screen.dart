import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memorie/constants/colors.dart';
import 'package:memorie/widgets/back_button.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 背景画像を設定したContainer
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('lib/assets/backgrounds/bg.png'),
            fit: BoxFit.cover,
            // 文字が見やすいように背景を暗くする
            colorFilter: ColorFilter.mode(
              AppColors.black.withOpacity(0.8),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 固定部分: Backボタンとタイトル
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Backボタン
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: BackButtonWidget(
                        label: 'Back',
                        iconColor: AppColors.black,
                        textColor: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // タイトル
                    Center(
                      child: Text(
                        'How to play',
                        style: GoogleFonts.rockSalt(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // スクロール可能なコンテンツ部分
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // セクション0: はじめに
                      Text(
                        '0.はじめに',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '　ダウンロードいただきありがとうございます。\n　Memorie(メモリエ)は記憶力を養う簡単なゲームです。\n　お手本を覚えて、タップで答えるだけのシンプルなゲームです。\n　習慣的にプレイすることで記憶力を向上させましょう！',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // セクション1: メモリータイム
                      Text(
                        '1.メモリータイム',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '　はじめにお手本が流れます。',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        '　しっかりと記憶しましょう',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // セクション2: タップタイム
                      Text(
                        '2.タップタイム',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '　お手本が流れた後、タップで答えます',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        '　正解すると次のステージのロックが解除されます',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ボーダー波線
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // セクション3: Tips
                      Text(
                        'Tips',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '　・ お手本をしっかりと覚えることが重要です',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '　・ お手本を覚えるときは、目で追うだけでなく、声に出して覚えると効果的です',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '　・ 今後、新ステージの追加やクリアステージ状態に応じたランキング機能を追加予定です。まだ見ぬユーザーと記憶力を競い合いましょう',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
