import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memorie/constants/colors.dart';
import 'package:memorie/models/stage.dart';
import 'package:memorie/screens/game_screen.dart';
import 'package:memorie/screens/sub_stage_selection_screen.dart';

class StageCard extends StatelessWidget {
  final Stage? stage;

  const StageCard({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (stage is GameStage) {
          // GameStageの場合はGameScreenへ遷移
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(gameStage: stage as GameStage),
            ),
          );
        } else if (stage is MainStage) {
          // MainStageの場合はSubStageSelectionScreenへ遷移
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SubStageSelectionScreen(stage: stage as MainStage),
            ),
          );
        }
      },
      child: Container(
          decoration: const BoxDecoration(
            color: AppColors.lightGrey,
            border: Border(
              top: BorderSide(color: AppColors.grey),
              left: BorderSide(color: AppColors.grey),
              bottom: BorderSide(color: AppColors.grey),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stage!.name,
                        style: GoogleFonts.rockSalt(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stage!.subName,
                        style: GoogleFonts.robotoSlab(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                // 画像
                child: Image(
                  image: AssetImage('lib/assets/backgrounds/lifew.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          )),
    );
  }
}
