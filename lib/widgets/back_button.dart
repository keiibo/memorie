// lib/widgets/back_button_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class BackButtonWidget extends StatelessWidget {
  final String label;
  final double iconSize;
  final double fontSize;
  final Color iconColor;
  final Color textColor;

  const BackButtonWidget({
    super.key,
    this.label = 'Back',
    this.iconSize = 24.0,
    this.fontSize = 18.0,
    this.iconColor = AppColors.black,
    this.textColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'lib/assets/icons/back.svg',
              width: iconSize,
              height: iconSize,
            ),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: GoogleFonts.rockSalt(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
