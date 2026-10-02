import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Card banner bagian bawah: 'Automatic logic' sebagai informational card
class AutomaticLogicCard extends StatelessWidget {
  const AutomaticLogicCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4), // Green 50 / Emerald soft
        borderRadius: AppRadius.borderMd,
        border: Border.all(
          color: const Color(0xFFDCFCE7), // Green 100
          width: 1.0,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Automatic logic',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'Controller uses sensor values, setpoints and limits to manage actuators.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
