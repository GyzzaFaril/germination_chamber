import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Painter minimalis untuk menggambar kurva telemetri dengan grid tipis dan garis dashed setpoint
class TelemetryChartPainter extends CustomPainter {
  final List<double> values1;
  final Color color1;
  final double min1;
  final double max1;

  final List<double>? values2;
  final Color? color2;
  final double? min2;
  final double? max2;

  final double? dashedYValue;
  final Color dashedColor;

  const TelemetryChartPainter({
    required this.values1,
    required this.color1,
    required this.min1,
    required this.max1,
    this.values2,
    this.color2,
    this.min2,
    this.max2,
    this.dashedYValue,
    this.dashedColor = const Color(0xFF94A3B8),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values1.isEmpty) return;

    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1.0;

    // 1. Gambar 4 garis horizontal grid tipis
    const gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = (size.height / gridLines) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Gambar dashed line (misal setpoint) jika ada
    if (dashedYValue != null) {
      final range1 = max1 - min1 == 0 ? 1.0 : max1 - min1;
      final normalized = ((dashedYValue! - min1) / range1).clamp(0.0, 1.0);
      final dashedY = size.height - (normalized * size.height);

      final dashPaint = Paint()
        ..color = dashedColor
        ..strokeWidth = 1.5;

      const dashWidth = 5.0;
      const dashSpace = 4.0;
      double startX = 0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, dashedY),
          Offset((startX + dashWidth).clamp(0.0, size.width), dashedY),
          dashPaint,
        );
        startX += dashWidth + dashSpace;
      }
    }

    // 3. Gambar Garis 2 (jika ada, misal Kelembapan)
    if (values2 != null && values2!.isNotEmpty && color2 != null) {
      _drawLineSeries(
        canvas: canvas,
        size: size,
        values: values2!,
        min: min2 ?? min1,
        max: max2 ?? max1,
        color: color2!,
      );
    }

    // 4. Gambar Garis 1 (Utama, misal Temperature / Light / Water Level)
    _drawLineSeries(
      canvas: canvas,
      size: size,
      values: values1,
      min: min1,
      max: max1,
      color: color1,
    );
  }

  void _drawLineSeries({
    required Canvas canvas,
    required Size size,
    required List<double> values,
    required double min,
    required double max,
    required Color color,
  }) {
    if (values.length < 2) return;

    final range = max - min == 0 ? 1.0 : max - min;
    final stepX = size.width / (values.length - 1);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.12),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final List<Offset> points = [];

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final normalized = ((values[i] - min) / range).clamp(0.0, 1.0);
      final y = (size.height - (normalized * (size.height - 8))) - 4;
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Gambar area fill lembut
    canvas.drawPath(fillPath, fillPaint);

    // Gambar garis
    canvas.drawPath(path, linePaint);

    // Gambar titik lingkaran pada data points
    final dotPaint = Paint()..color = color;
    final dotInnerPaint = Paint()..color = Colors.white;

    for (final pt in points) {
      canvas.drawCircle(pt, 3.5, dotPaint);
      canvas.drawCircle(pt, 1.8, dotInnerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TelemetryChartPainter oldDelegate) {
    return oldDelegate.values1 != values1 ||
        oldDelegate.values2 != values2 ||
        oldDelegate.dashedYValue != dashedYValue;
  }
}

/// Widget pembungkus grafik telemetri dengan label sumbu X di bagian bawah
class TelemetryLineChart extends StatelessWidget {
  final List<String> timeLabels;
  final List<double> values1;
  final Color color1;
  final double min1;
  final double max1;

  final List<double>? values2;
  final Color? color2;
  final double? min2;
  final double? max2;

  final double? dashedYValue;
  final Color dashedColor;
  final double height;

  const TelemetryLineChart({
    super.key,
    required this.timeLabels,
    required this.values1,
    required this.color1,
    required this.min1,
    required this.max1,
    this.values2,
    this.color2,
    this.min2,
    this.max2,
    this.dashedYValue,
    this.dashedColor = const Color(0xFF94A3B8),
    this.height = 160.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: TelemetryChartPainter(
              values1: values1,
              color1: color1,
              min1: min1,
              max1: max1,
              values2: values2,
              color2: color2,
              min2: min2,
              max2: max2,
              dashedYValue: dashedYValue,
              dashedColor: dashedColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Sumbu X: Label Waktu
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: timeLabels
              .map(
                (label) => Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightTextMuted,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
