// lib/screens/sub_stage_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:memorie/constants/colors.dart';
import 'package:memorie/models/stage.dart';
import 'package:memorie/widgets/back_button.dart';
import 'package:memorie/widgets/stage_card.dart';

class SubStageSelectionScreen extends StatelessWidget {
  final MainStage stage;

  const SubStageSelectionScreen({super.key, required this.stage});

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
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft, // ボタンを左揃え
                  child: BackButtonWidget(
                      label: 'Back', // 必要に応じてラベルを変更
                      iconColor: AppColors.black,
                      textColor: AppColors.black),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    itemCount: stage.gameStages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // 横に表示するアイテム数
                      mainAxisSpacing: 4.0, // アイテム間の縦スペース
                      childAspectRatio: 4 / 1, // アイテムの幅と高さの比率
                    ),
                    itemBuilder: (context, index) {
                      final subStage = stage.gameStages[index];
                      return StageCard(stage: subStage);
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
