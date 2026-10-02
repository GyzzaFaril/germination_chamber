import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_context.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_card.dart';

/// Screen utama untuk modul Sensor
class SensorScreen extends StatelessWidget {
  const SensorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.isDesktop ? 1200 : double.infinity,
          ),
          child: ListView(
            padding: context.isDesktop ? AppSpacing.paddingAllXl : AppSpacing.paddingAllMd,
            children: const [
              AppCard(
                child: Row(
                  children: [
                    Icon(
                      Icons.sensors_rounded,
                      size: 40,
                      color: AppColors.warning,
                    ),
                    AppSpacing.horizontalMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Modul Sensor',
                            style: AppTypography.titleLarge,
                          ),
                          AppSpacing.verticalXs,
                          Text(
                            'Fondasi modul siap. UI akan diimplementasikan sesuai desain Figma.',
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
