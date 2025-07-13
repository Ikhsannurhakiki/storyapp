import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:storyapp/style/colors/app_colors.dart';

class LoaderAnimation extends CustomPainter {
  final double angle;
  final double progress;

  LoaderAnimation({required this.angle, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = AppColors.navyBlue.color
      ..strokeWidth = 10.0;

    Offset startPoint = Offset(0, size.height * 0.4);
    Offset endPoint = Offset(size.width, size.height * 0.6);

    canvas.drawLine(startPoint, endPoint, linePaint);

    final double progress = this.progress.clamp(0.0, 1.0);
    final Offset movingCenter = Offset.lerp(startPoint, endPoint, progress)!;

    canvas.save();
    canvas.translate(movingCenter.dx, movingCenter.dy);
    canvas.rotate(angle);

    const double radius = 45;
    final Rect circleRect = Rect.fromCircle(
      center: Offset.zero,
      radius: radius,
    );

    final Paint orangePaint = Paint()
      ..color = AppColors.lightTeal.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    final Paint bluePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    canvas.drawArc(circleRect, 0, math.pi, true, orangePaint);

    canvas.drawArc(circleRect, math.pi, math.pi, true, bluePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LoaderAnimation oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.angle != angle;
  }
}
