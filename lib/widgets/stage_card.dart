import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memorie/constants/colors.dart';
import 'package:memorie/models/stage.dart';

class StageCard extends StatelessWidget {
  final Stage stage;

  const StageCard({super.key, required this.stage});

  bool get _isLocked {
    if (stage is GameStage) {
      return !(stage as GameStage).isUnlocked;
    } else if (stage is MainStage) {
      return !(stage as MainStage).isUnlocked;
    }
    return false; // それ以外のStageはロック概念なし
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stage.name,
                        style: GoogleFonts.rockSalt(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stage.subName,
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
              Expanded(
                flex: 1,
                child: Image(
                  image: stage is MainStage
                      ? AssetImage(stage.stageThumbnailImage)
                      : AssetImage((stage as GameStage).stageThumbnailImage),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
        if (_isLocked)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
