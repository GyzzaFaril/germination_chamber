import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Card informasi read-only untuk status aktuator dan sistem chamber
class ChamberStatusCard extends StatelessWidget {
  final String mode;
  final String mistMaker;
  final String blower;
  final String intakeFan;
  final String exhaustFan;
  final String system;

  const ChamberStatusCard({
    super.key,
    this.mode = 'AUTO',
    this.mistMaker = 'OFF',
    this.blower = 'ON',
    this.intakeFan = '60 %',
    this.exhaustFan = '50 %',
    this.system = 'Online',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderMd,
        border: Border.all(
          color: AppColors.lightBorder,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          const Row(
            children: [
              Icon(
                Icons.tune_outlined,
                size: 20,
                color: AppColors.lightTextPrimary,
              ),
              SizedBox(width: 10),
              Text(
                'Chamber Status',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Layout 2 Kolom Status Read-Only
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kolom 1: Mode, Mist Maker, Blower
              Expanded(
                child: Column(
                  children: [
                    _buildStatusRow(
                      label: 'Mode',
                      valueWidget: _buildBadge(
                        text: mode,
                        bgColor: const Color(0xFFF0FDF4),
                        textColor: AppColors.primary,
                        borderColor: const Color(0xFFBBF7D0),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildStatusRow(
                      label: 'Mist Maker',
                      valueWidget: _buildBadge(
                        text: mistMaker,
                        bgColor: mistMaker == 'ON'
                            ? const Color(0xFFF0FDF4)
                            : const Color(0xFFF1F5F9),
                        textColor: mistMaker == 'ON'
                            ? AppColors.primary
                            : AppColors.lightTextSecondary,
                        borderColor: mistMaker == 'ON'
                            ? const Color(0xFFBBF7D0)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildStatusRow(
                      label: 'Blower',
                      valueWidget: _buildBadge(
                        text: blower,
                        bgColor: blower == 'ON'
                            ? const Color(0xFFF0FDF4)
                            : const Color(0xFFF1F5F9),
                        textColor: blower == 'ON'
                            ? AppColors.primary
                            : AppColors.lightTextSecondary,
                        borderColor: blower == 'ON'
                            ? const Color(0xFFBBF7D0)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // Kolom 2: Intake Fan, Exhaust Fan, System
              Expanded(
                child: Column(
                  children: [
                    _buildStatusRow(
                      label: 'Intake Fan',
                      valueWidget: Text(
                        intakeFan,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildStatusRow(
                      label: 'Exhaust Fan',
                      valueWidget: Text(
                        exhaustFan,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildStatusRow(
                      label: 'System',
                      valueWidget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 7,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            system,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow({
    required String label,
    required Widget valueWidget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.lightTextSecondary,
          ),
        ),
        valueWidget,
      ],
    );
  }

  Widget _buildBadge({
    required String text,
    required Color bgColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
