import 'package:flutter/material.dart';

class BrushBackgroundPainter extends CustomPainter {
  final List<Path> brushPaths;
  final List<Offset> splatterPositions;
  final Color color;
  final double splatterRadius;

  BrushBackgroundPainter({
    required this.brushPaths,
    required this.splatterPositions,
    this.color = Colors.blueAccent,
    this.splatterRadius = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // ブラシストロークを描画
    for (final path in brushPaths) {
      canvas.drawPath(path, paint);
    }

    // スプラッターを描画
    final splatterPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    for (final offset in splatterPositions) {
      canvas.drawCircle(offset, splatterRadius, splatterPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
