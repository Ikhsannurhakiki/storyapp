import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:storyapp/style/colors/app_colors.dart';

class LoaderAnimation extends CustomPainter {
  final double angle;
  final double progress;

  LoaderAnimation({required this.angle, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw the horizontal line
    Paint linePaint = Paint()
      ..color = AppColors.navyBlue.color
      ..strokeWidth = 10.0;

    Offset startPoint = Offset(
      0,
      size.height * 0.4,
    ); // Line's vertical position
    Offset endPoint = Offset(size.width, size.height * 0.6);

    canvas.drawLine(startPoint, endPoint, linePaint);

    // 2. Compute moving center along the line
    final double progress = this.progress.clamp(0.0, 1.0); // safe range
    final Offset movingCenter = Offset.lerp(startPoint, endPoint, progress)!;

    // 3. Save and move canvas to center of the ball
    canvas.save();
    canvas.translate(movingCenter.dx, movingCenter.dy);
    canvas.rotate(angle); // Roll the ball

    // 4. Draw the 2-colored ball
    const double radius = 45;
    final Rect circleRect = Rect.fromCircle(
      center: Offset.zero,
      radius: radius,
    );

    final Paint orangePaint = Paint()..color = AppColors.lightTeal.color..style = PaintingStyle.stroke..strokeWidth = 5;
    final Paint bluePaint = Paint()..color = Colors.black..style = PaintingStyle.stroke;

    // Left half
    canvas.drawArc(circleRect, 0, math.pi, true, orangePaint);
    // Right half
    canvas.drawArc(circleRect, math.pi, math.pi, true, bluePaint);

    canvas.restore(); // restore canvas state
  }

  @override
  bool shouldRepaint(covariant LoaderAnimation oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.angle != angle;
  }
}
