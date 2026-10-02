import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../models/dashboard_data_model.dart';

/// Card untuk Status Perangkat (Aktuator)
class DeviceStatusCard extends StatelessWidget {
  final List<ActuatorDevice> actuators;

  const DeviceStatusCard({super.key, required this.actuators});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.lightBorder, width: 1.0),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Judul & Subtitle
          const Text(
            'Status Perangkat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Kondisi aktuator saat ini',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.lightTextSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),

          // Grid 2x2 Aktuator
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 450;
              if (isNarrow) {
                return Column(
                  children: actuators.map((actuator) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildActuatorItem(actuator),
                    );
                  }).toList(),
                );
              }

              return Column(
                children: [
                  Row(
                    children: [
                      if (actuators.isNotEmpty)
                        Expanded(child: _buildActuatorItem(actuators[0])),
                      const SizedBox(width: 14),
                      if (actuators.length > 1)
                        Expanded(child: _buildActuatorItem(actuators[1])),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      if (actuators.length > 2)
                        Expanded(child: _buildActuatorItem(actuators[2])),
                      const SizedBox(width: 14),
                      if (actuators.length > 3)
                        Expanded(child: _buildActuatorItem(actuators[3])),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActuatorItem(ActuatorDevice actuator) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderSm,
        border: Border.all(color: AppColors.lightBorder, width: 1.0),
      ),
      child: Row(
        children: [
          // Icon untuk perangkat aktuator
          if (actuator.name.toLowerCase().contains('mist')) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: AppRadius.borderSm,
              ),
              child: const Icon(
                Icons.air,
                size: 24,
                color: Color(0xFF0284C7),
              ),
            ),
            const SizedBox(width: 12),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.borderSm,
                border: Border.all(color: AppColors.lightBorder, width: 1.0),
              ),
              child: const SizedBox(
                width: 24,
                height: 24,
                child: CustomPaint(
                  painter: _FanPainter(color: AppColors.lightTextPrimary),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Nama & Deskripsi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actuator.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  actuator.description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Status & Mode
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actuator.stateText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                actuator.modeText,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter untuk menggambar icon fan 3 bilah melingkar sesuai desain Figma
class _FanPainter extends CustomPainter {
  final Color color;

  const _FanPainter({required this.color});

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
      final angle = (i * 120.0) * (3.141592653589793 / 180.0);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);

      final path = Path();
      path.moveTo(0, 0);
      final bladeLen = radius * 0.72;
      path.cubicTo(
        radius * 0.25, -radius * 0.15,
        radius * 0.55, -radius * 0.35,
        bladeLen, -radius * 0.08,
      );
      path.cubicTo(
        bladeLen * 0.85, radius * 0.15,
        radius * 0.35, radius * 0.15,
        0, 0,
      );
      path.close();
      canvas.drawPath(path, fillPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _FanPainter oldDelegate) => oldDelegate.color != color;
}
