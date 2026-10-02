import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../features/setpoint/services/setpoint_protection.dart';
import '../../features/settings/services/calibration_protection.dart';

/// Sidebar desktop sesuai desain Figma Germination Chamber
class AppSidebar extends StatelessWidget {
  final String currentLocation;

  const AppSidebar({super.key, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: double.infinity,
      color: AppColors.sidebarBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Branding Header (Logo Leaf + Teks Germination Chamber)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 28),
            child: Row(
              children: [
                // Logo Daun Putih Khas Germination Chamber (tanpa kotak container putih)
                const Icon(
                  Icons.energy_savings_leaf,
                  size: 34,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),

                // Nama Brand
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'GERMINATION',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          height: 1.15,
                        ),
                      ),
                      Text(
                        'CHAMBER',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'SMART CONTROL SYSTEM',
                        style: TextStyle(
                          fontSize: 7.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Daftar Menu Navigasi Sesuai Referensi Figma Terbaru
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                _buildMenuItem(
                  context,
                  title: 'Beranda',
                  icon: Icons.home,
                  route: AppRoutes.dashboard,
                  isSelected: currentLocation == AppRoutes.dashboard,
                ),
                const SizedBox(height: 4),
                _buildMenuItem(
                  context,
                  title: 'Kontrol Perangkat',
                  icon: Icons.tune,
                  route: AppRoutes.deviceControl,
                  isSelected: currentLocation.startsWith(AppRoutes.deviceControl),
                ),
                const SizedBox(height: 4),
                _buildMenuItem(
                  context,
                  title: 'Setpoint',
                  icon: Icons.thermostat_outlined,
                  route: AppRoutes.setpoint,
                  isSelected: currentLocation.startsWith(AppRoutes.setpoint),
                ),
                const SizedBox(height: 4),
                _buildMenuItem(
                  context,
                  title: 'Monitoring',
                  icon: Icons.bar_chart_rounded,
                  route: AppRoutes.monitoring,
                  isSelected: currentLocation.startsWith(AppRoutes.monitoring),
                ),
                const SizedBox(height: 4),
                _buildMenuItem(
                  context,
                  title: 'Alarm & Notifikasi',
                  icon: Icons.notifications,
                  route: AppRoutes.notifications,
                  isSelected: currentLocation.startsWith(AppRoutes.notifications),
                ),
                const SizedBox(height: 4),
                _buildMenuItem(
                  context,
                  title: 'Pengaturan',
                  icon: Icons.settings_outlined,
                  route: AppRoutes.settings,
                  isSelected: currentLocation.startsWith(AppRoutes.settings),
                ),
              ],
            ),
          ),

          // 3. Garis Pembatas (Divider)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: Colors.white24,
              height: 1,
              thickness: 1,
            ),
          ),

          // 4. Status Sistem di Bagian Bawah Sidebar
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SYSTEM STATUS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Sistem Online',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'AUTO MODE',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData? icon,
    required String route,
    required bool isSelected,
  }) {
    return Material(
      color: isSelected ? const Color(0x28FFFFFF) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () async {
          if (!isSelected) {
            // Navigation guard saat meninggalkan Setpoint dengan perubahan yang belum disimpan
            if (currentLocation.startsWith(AppRoutes.setpoint) &&
                SetpointProtection.hasUnsavedChanges) {
              final proceed =
                  await SetpointProtection.confirmNavigation(context);
              if (!proceed) return;
            }
            if (!context.mounted) return;
            // Navigation guard saat meninggalkan Kalibrasi Sensor dengan perubahan yang belum disimpan
            if (currentLocation.startsWith(AppRoutes.settingsCalibration) &&
                CalibrationProtection.hasUnsavedChanges) {
              final proceed =
                  await CalibrationProtection.confirmNavigation(context);
              if (!proceed) return;
            }
            if (context.mounted) {
              context.go(route);
            }
          }
        },
        borderRadius: BorderRadius.circular(8),
        hoverColor: const Color(0x18FFFFFF),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9),
                ),
                const SizedBox(width: 12),
              ] else ...[
                const SizedBox(width: 32), // Indentasi agar sejajar dengan item yang berikon
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
