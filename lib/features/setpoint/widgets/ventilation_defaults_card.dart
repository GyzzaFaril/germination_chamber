import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Card sisi kanan: 'Ventilation defaults' yang menampilkan default mode AUTO (read-only)
class VentilationDefaultsCard extends StatelessWidget {
  final int intakeFanSpeed;
  final int exhaustFanSpeed;
  final int blowerDelaySeconds;

  const VentilationDefaultsCard({
    super.key,
    this.intakeFanSpeed = 60,
    this.exhaustFanSpeed = 50,
    this.blowerDelaySeconds = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.lightBorder, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Judul
          const Text(
            'Ventilation defaults',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 3),
          // Subtitle
          const Text(
            'Used by AUTO mode',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.lightTextSecondary,
            ),
          ),

          const SizedBox(height: 24),

          // 1. Intake Fan
          _buildDefaultRow(
            label: 'Intake fan',
            valueText: '$intakeFanSpeed %',
          ),

          const SizedBox(height: 20),

          // 2. Exhaust Fan
          _buildDefaultRow(
            label: 'Exhaust fan',
            valueText: '$exhaustFanSpeed %',
          ),

          const SizedBox(height: 20),

          // 3. Blower delay after Mist OFF
          _buildDefaultRow(
            label: 'Blower delay after Mist OFF',
            valueText: '$blowerDelaySeconds s',
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultRow({
    required String label,
    required String valueText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ),
        Text(
          valueText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
