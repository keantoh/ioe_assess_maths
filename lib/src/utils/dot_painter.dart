import 'package:flutter/material.dart';
import 'package:math_assessment/src/models/dot_paint_option.dart';

class DotsPainter extends CustomPainter {
  final List<DotPaintOption> dots;
  final double canvasWidth;
  final double canvasHeight;
  final Color color;

  DotsPainter(this.dots, this.canvasWidth, this.canvasHeight, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (DotPaintOption dot in dots) {
      canvas.drawCircle(Offset(dot.x * canvasWidth, dot.y * canvasHeight),
          dot.radius * canvasHeight, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
