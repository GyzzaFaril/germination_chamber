import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom painter untuk menggambar icon fan 3 bilah melingkar sesuai desain Figma
class DeviceFanPainter extends CustomPainter {
  final Color color;

  const DeviceFanPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Lingkaran luar
    canvas.drawCircle(center, radius - 1.0, strokePaint);

    // Hub kecil di tengah
    canvas.drawCircle(center, 2.0, fillPaint);

    // 3 bilah kipas melingkar
    for (int i = 0; i < 3; i++) {
      final angle = (i * 120.0) * (math.pi / 180.0);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);

      final path = Path();
      path.moveTo(0, 0);
      final bladeLen = radius * 0.72;
      path.cubicTo(
        radius * 0.25,
        -radius * 0.15,
        radius * 0.55,
        -radius * 0.35,
        bladeLen,
        -radius * 0.08,
      );
      path.cubicTo(
        bladeLen * 0.85,
        radius * 0.15,
        radius * 0.35,
        radius * 0.15,
        0,
        0,
      );
      path.close();
      canvas.drawPath(path, fillPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant DeviceFanPainter oldDelegate) =>
      oldDelegate.color != color;
}
