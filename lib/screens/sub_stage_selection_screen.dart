import 'package:flutter/material.dart';
import 'package:memorie/constants/colors.dart';
import 'package:memorie/models/stage.dart';
import 'package:memorie/screens/game_screen.dart';
import 'package:memorie/widgets/back_button.dart';
import 'package:memorie/widgets/stage_card.dart';

class SubStageSelectionScreen extends StatefulWidget {
  final MainStage stage;

  const SubStageSelectionScreen({super.key, required this.stage});

  @override
  State<SubStageSelectionScreen> createState() =>
      _SubStageSelectionScreenState();
}

class _SubStageSelectionScreenState extends State<SubStageSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/backgrounds/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft, // ボタンを左揃え
                  child: BackButtonWidget(
                      label: 'Back',
                      iconColor: AppColors.black,
                      textColor: AppColors.black),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    itemCount: widget.stage.gameStages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // 横に表示するアイテム数
                      mainAxisSpacing: 4.0, // アイテム間の縦スペース
                      childAspectRatio: 4 / 1, // アイテムの幅と高さの比率
                    ),
                    itemBuilder: (context, index) {
                      final subStage = widget.stage.gameStages[index];
                      return GestureDetector(
                        onTap: () async {
                          // ロックされている場合はタップ無効
                          if (!subStage.isUnlocked) {
                            return;
                          }

                          // GameStageの場合はGameScreenへ遷移し、結果をawait
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameScreen(
                                gameStage: subStage,
                                backGroundImagePath: subStage.stageCardImage,
                              ),
                            ),
                          );

                          if (result == true) {
                            // ここでクリアした `clearedStage` のIDやindexから、次のステージがあるか判定
                            final currentIndex =
                                widget.stage.gameStages.indexOf(subStage);
                            final isLast = currentIndex ==
                                widget.stage.gameStages.length - 1;
                            if (isLast) {
                              // 最後のステージをクリアしたのでメインステージ選択画面に戻る
                              Navigator.pop(context, true);
                            } else {
                              // 次のサブステージがあるので SubStageSelectionScreen にとどまる
                              // ここで setState() するなど、UI更新する
                              setState(() {});
                              // Navigator.popせず、そのままSubStageSelectionScreenに留まる
                            }
                          }
                        },
                        child: StageCard(stage: subStage),
                      );
                    },
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
