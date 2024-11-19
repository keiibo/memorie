// lib/widgets/back_button_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingButtonWidget extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final Color iconColor;

  const SettingButtonWidget({
    super.key,
    required this.iconSize,
    required this.fontSize,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("歯車がタップされました");
        // TODO.設定オーバーレイを開く
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'lib/assets/icons/setting.svg',
              width: iconSize,
              height: iconSize,
            ),
          ],
        ),
      ),
    );
  }
}
