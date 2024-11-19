// lib/widgets/grid_cell_widget.dart

import 'package:flutter/material.dart';
import '../constants/colors.dart';

class GridCellWidget extends StatefulWidget {
  final bool isActive; // アクティブ時のみタップ可能になる
  final bool isMisTapped; // 誤タップ時の色を変更
  final bool isCorrectTapped; // 正解タップ時の色を変更
  final bool isUserTurn;
  final VoidCallback onTap;

  const GridCellWidget({
    super.key,
    required this.isActive,
    required this.onTap,
    required this.isUserTurn,
    required this.isMisTapped,
    required this.isCorrectTapped,
  });

  @override
  _GridCellWidgetState createState() => _GridCellWidgetState();
}

class _GridCellWidgetState extends State<GridCellWidget> {
  void handleTap() {
    if (widget.isUserTurn) {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isUserTurn ? handleTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: widget.isMisTapped
              ? Colors.red.withOpacity(0.7)
              : (widget.isCorrectTapped
                  ? AppColors.cream.withOpacity(0.7)
                  : (widget.isActive
                      ? AppColors.cream.withOpacity(0.7)
                      : AppColors.grey)),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // 縦向きに影を追加
            ),
            if (widget.isActive && !widget.isMisTapped)
              BoxShadow(
                color: Colors.yellow.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 15,
                offset: const Offset(0, 0), // 全体的に光っているように見せる
              ),
          ],
        ),
        child: const Center(
          child: SizedBox.shrink(),
        ),
      ),
    );
  }
}
