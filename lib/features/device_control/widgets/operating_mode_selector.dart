import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Komponen selector Operating mode (Global Mass Control)
/// Mendukung kondisi All Auto, All Manual, dan Mixed (kombinasi)
class OperatingModeSelector extends StatelessWidget {
  final bool isAllAuto;
  final bool isAllManual;
  final VoidCallback onSetAllAuto;
  final VoidCallback onSetAllManual;

  const OperatingModeSelector({
    super.key,
    required this.isAllAuto,
    required this.isAllManual,
    required this.onSetAllAuto,
    required this.onSetAllManual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.lightBorder, width: 1.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 750;

          final labelWidget = const Text(
            'Operating mode',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
          );

          final buttonsWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModeButton(
                title: 'AUTO',
                isActive: isAllAuto,
                onTap: onSetAllAuto,
              ),
              const SizedBox(width: 8),
              _buildModeButton(
                title: 'MANUAL',
                isActive: isAllManual,
                onTap: onSetAllManual,
              ),
            ],
          );

          String description;
          if (isAllAuto) {
            description =
                'Automatic rules active: sensor values and setpoints control the actuators.';
          } else if (isAllManual) {
            description =
                'Manual mode: automatic control is disabled while manual controls are active.';
          } else {
            description =
                'Mixed mode: some actuators are in manual control while others follow automatic rules.';
          }

          final descriptionWidget = Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.lightTextSecondary,
            ),
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    labelWidget,
                    buttonsWidget,
                  ],
                ),
                const SizedBox(height: 10),
                descriptionWidget,
              ],
            );
          }

          return Row(
            children: [
              labelWidget,
              const SizedBox(width: 24),
              buttonsWidget,
              const SizedBox(width: 24),
              Expanded(child: descriptionWidget),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModeButton({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : const Color(0xFF475569),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
