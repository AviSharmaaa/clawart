import 'package:flutter/material.dart';
import '../models/model.dart';

class CanvasPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  CanvasPainter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;

      drawingPoint.offsets.length == 1
          ? _drawSinglePoint(canvas, drawingPoint, paint)
          : _drawPath(canvas, drawingPoint, paint);
    }
  }

  void _drawSinglePoint(Canvas canvas, DrawingPoint point, Paint paint) {
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(point.offsets.last, 2, paint);
  }

  void _drawPath(Canvas canvas, DrawingPoint point, Paint paint) {
    final path = Path();
    paint.style = PaintingStyle.stroke;
    path.moveTo(point.offsets.first.dx, point.offsets.first.dy);

    for (int i = 0; i < point.offsets.length - 1; i++) {
      final p0 = point.offsets[i];
      final p1 = point.offsets[i + 1];
      path.quadraticBezierTo(
        p0.dx,
        p0.dy,
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) => true;
}
