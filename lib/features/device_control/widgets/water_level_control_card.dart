import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Card horizontal khusus untuk Water Level dengan alignment kolom yang sama:
/// [ ICON ] [ DEVICE INFORMATION ] [ VALUE ] [ STATUS ] [ EMPTY ]
class WaterLevelControlCard extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final String percentage;

  const WaterLevelControlCard({
    super.key,
    this.title = 'Water Level',
    this.description = 'Mist Maker Dijalankan',
    this.status = 'Normal',
    this.percentage = '80 %',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.lightBorder, width: 1.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 650;

          final iconWidget = Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.water_drop,
              size: 26,
              color: Color(0xFF0284C7),
            ),
          );

          final titleWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          );

          // Kolom VALUE (width: 70) tepat pada posisi vertikal yang sama
          final valueWidget = SizedBox(
            width: 70,
            child: Text(
              percentage,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          );

          // Kolom Status "Normal" (width: 170) sejajar dengan kolom Mode
          final statusWidget = SizedBox(
            width: 170,
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          );

          // Kolom Kosong (width: 230) sejajar dengan kontrol manual
          const emptyControlWidget = SizedBox(
            width: 230,
            child: SizedBox.shrink(),
          );

          if (isNarrow) {
            return Row(
              children: [
                iconWidget,
                const SizedBox(width: 14),
                Expanded(child: titleWidget),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      percentage,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          // Desktop: Layout 5 kolom dengan alignment vertikal sempurna
          return Row(
            children: [
              iconWidget,
              const SizedBox(width: 16),
              Expanded(child: titleWidget),
              const SizedBox(width: 16),
              valueWidget,
              const SizedBox(width: 20),
              statusWidget,
              const SizedBox(width: 20),
              emptyControlWidget,
            ],
          );
        },
      ),
    );
  }
}
