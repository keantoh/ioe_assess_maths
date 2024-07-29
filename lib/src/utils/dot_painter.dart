import 'package:flutter/material.dart';
import 'package:math_assessment/src/data/models/dot_paint.dart';

class DotsPainter extends CustomPainter {
  final List<DotPaint> dots;
  final double canvasWidth;
  final double canvasHeight;

  DotsPainter(this.dots, this.canvasWidth, this.canvasHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    for (DotPaint dot in dots) {
      canvas.drawCircle(Offset(dot.x * canvasWidth, dot.y * canvasHeight),
          dot.radius * canvasHeight, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
