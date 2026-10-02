import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive_context.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../widgets/settings_header.dart';

/// Sub-page read-only untuk menampilkan Informasi Sistem, Controller, dan Perangkat Keras
class SystemInformationScreen extends StatelessWidget {
  const SystemInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Konsisten
            SettingsHeader(
              title: 'System Information',
              subtitle: 'View controller and application information',
              onBack: () => context.go(AppRoutes.settings),
            ),

            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.lightBorder,
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 28.0 : 16.0,
                vertical: isDesktop ? 24.0 : 16.0,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 880),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SECTION 1: APPLICATION
                      _buildSectionCard(
                        icon: Icons.apps_rounded,
                        iconColor: const Color(0xFF0284C7),
                        iconBg: const Color(0xFFF0F9FF),
                        title: 'Application',
                        rows: const [
                          _InfoRow(
                            label: 'Application Name',
                            value: AppConstants.appName,
                          ),
                          _InfoRow(
                            label: 'Version',
                            value: '1.0.0',
                          ),
                          _InfoRow(
                            label: 'Build',
                            value: 'Build 2025.1',
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // SECTION 2: CONTROLLER
                      _buildSectionCard(
                        icon: Icons.memory_rounded,
                        iconColor: AppColors.primary,
                        iconBg: const Color(0xFFF0FDF4),
                        title: 'Controller',
                        rows: const [
                          _InfoRow(
                            label: 'Controller',
                            value: 'Germination Chamber Controller',
                          ),
                          _InfoRow(
                            label: 'Connection',
                            value: 'Online',
                            isStatus: true,
                            statusColor: AppColors.primary,
                          ),
                          _InfoRow(
                            label: 'Firmware',
                            value: '---',
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // SECTION 3: HARDWARE
                      _buildSectionCard(
                        icon: Icons.hardware_rounded,
                        iconColor: const Color(0xFFD97706),
                        iconBg: const Color(0xFFFFFBEB),
                        title: 'Hardware',
                        rows: const [
                          _InfoRow(
                            label: 'Platform',
                            value: 'Mini PC',
                          ),
                          _InfoRow(
                            label: 'Sensors',
                            value: '4',
                          ),
                          _InfoRow(
                            label: 'Actuators',
                            value: '4',
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // SECTION 4: SYSTEM
                      _buildSectionCard(
                        icon: Icons.health_and_safety_rounded,
                        iconColor: const Color(0xFF0D9488),
                        iconBg: const Color(0xFFF0FDFA),
                        title: 'System',
                        rows: const [
                          _InfoRow(
                            label: 'System Status',
                            value: 'Normal / Operational',
                            isStatus: true,
                            statusColor: AppColors.primary,
                          ),
                          _InfoRow(
                            label: 'Last Sync',
                            value: 'Just now',
                          ),
                          _InfoRow(
                            label: 'Diagnostics Report',
                            value: 'All telemetry channels nominal',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required List<_InfoRow> rows,
  }) {
    return Container(
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
          // Section Card Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.lightBorder,
          ),

          // Section Rows
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: rows.map((row) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 170,
                        child: Text(
                          row.label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: row.isStatus
                            ? Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color:
                                          row.statusColor ?? AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    row.value,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: row.statusColor ??
                                          AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                row.value,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lightTextPrimary,
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  final bool isStatus;
  final Color? statusColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isStatus = false,
    this.statusColor,
  });
}
