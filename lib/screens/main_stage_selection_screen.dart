import 'package:flutter/material.dart';
import 'package:memorie/constants/colors.dart';
import 'package:memorie/constants/stage_list.dart';
import 'package:memorie/screens/sub_stage_selection_screen.dart';
import 'package:memorie/widgets/back_button.dart';
import 'package:memorie/widgets/stage_card.dart';

class StageSelectionScreen extends StatefulWidget {
  const StageSelectionScreen({super.key});

  @override
  State<StageSelectionScreen> createState() => _StageSelectionScreenState();
}

class _StageSelectionScreenState extends State<StageSelectionScreen> {
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
                    label: 'Back',
                    iconColor: AppColors.black,
                    textColor: AppColors.black,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    itemCount: stages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // 横に表示するアイテム数は1
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 4 / 1,
                    ),
                    itemBuilder: (context, index) {
                      final stage = stages[index]; // ここはMainStageが格納されている想定
                      return GestureDetector(
                        onTap: () async {
                          // MainStageをタップしたらSubStageSelectionScreenへ
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SubStageSelectionScreen(stage: stage),
                            ),
                          );

                          // resultがtrueならアンロック状態が更新された可能性あり
                          if (result == true) {
                            setState(() {
                              // setStateを呼ぶことでUIが再ビルドされ、
                              // アンロック状態が反映される
                            });
                          }
                        },
                        child: StageCard(stage: stage),
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
