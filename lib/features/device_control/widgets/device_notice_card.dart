import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Card informasi "Catatan" berwarna biru muda di bagian bawah halaman
class DeviceNoticeCard extends StatelessWidget {
  const DeviceNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: AppRadius.borderMd,
        border: Border.all(
          color: const Color(0xFFBAE6FD),
          width: 1.0,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.info,
            size: 28,
            color: Color(0xFF0284C7),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Catatan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Pada mode MANUAL, kontrol otomatis dinonaktifkan',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
