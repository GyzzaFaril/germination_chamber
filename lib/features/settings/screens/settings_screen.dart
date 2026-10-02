import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/responsive/responsive_context.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../services/settings_controller.dart';
import '../widgets/reset_confirm_dialog.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_menu_card.dart';

/// Screen utama untuk modul Pengaturan
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _handleReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const ResetConfirmDialog(),
    );

    if (confirmed == true && context.mounted) {
      SettingsController.instance.resetToDefault();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings restored to default'),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Konsisten
            const SettingsHeader(
              title: 'Settings',
              subtitle: 'Configure application and system preferences',
            ),

            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.lightBorder,
            ),

            // 2. Daftar Menu Pengaturan
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 28.0 : 16.0,
                vertical: isDesktop ? 24.0 : 16.0,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 880),
                  child: ListenableBuilder(
                    listenable: SettingsController.instance,
                    builder: (context, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Sensor Calibration
                          SettingsMenuCard(
                            key: const Key('settings_menu_calibration'),
                            icon: Icons.tune,
                            title: 'Sensor Calibration',
                            subtitle:
                                'Adjust sensor readings and calibration offsets',
                            iconColor: AppColors.primary,
                            iconBackgroundColor: const Color(0xFFF0FDF4),
                            onTap: () =>
                                context.go(AppRoutes.settingsCalibration),
                          ),

                          const SizedBox(height: 12),

                          // 2. Date & Time
                          SettingsMenuCard(
                            key: const Key('settings_menu_date_time'),
                            icon: Icons.schedule_rounded,
                            title: 'Date & Time',
                            subtitle: 'Configure date, time and timezone',
                            iconColor: const Color(0xFF0284C7),
                            iconBackgroundColor: const Color(0xFFF0F9FF),
                            onTap: () =>
                                context.go(AppRoutes.settingsDateTime),
                          ),

                          const SizedBox(height: 12),

                          // 3. Appearance
                          SettingsMenuCard(
                            key: const Key('settings_menu_appearance'),
                            icon: Icons.palette_outlined,
                            title: 'Appearance',
                            subtitle: 'Customize application appearance',
                            iconColor: const Color(0xFF7C3AED),
                            iconBackgroundColor: const Color(0xFFF5F3FF),
                            onTap: () =>
                                context.go(AppRoutes.settingsAppearance),
                          ),

                          const SizedBox(height: 12),

                          // 4. Language
                          SettingsMenuCard(
                            key: const Key('settings_menu_language'),
                            icon: Icons.language_rounded,
                            title: 'Language',
                            subtitle: 'Choose application language',
                            iconColor: const Color(0xFF0D9488),
                            iconBackgroundColor: const Color(0xFFF0FDFA),
                            onTap: () =>
                                context.go(AppRoutes.settingsLanguage),
                          ),

                          const SizedBox(height: 12),

                          // 5. System Information
                          SettingsMenuCard(
                            key: const Key('settings_menu_system_info'),
                            icon: Icons.info_outline_rounded,
                            title: 'System Information',
                            subtitle:
                                'View controller and application information',
                            iconColor: const Color(0xFF3B82F6),
                            iconBackgroundColor: const Color(0xFFEFF6FF),
                            onTap: () =>
                                context.go(AppRoutes.settingsSystemInfo),
                          ),

                          const SizedBox(height: 12),

                          // 6. Reset Settings
                          SettingsMenuCard(
                            key: const Key('settings_menu_reset'),
                            icon: Icons.restore_rounded,
                            title: 'Reset Settings',
                            subtitle: 'Restore application settings to default',
                            iconColor: AppColors.error,
                            iconBackgroundColor: const Color(0xFFFEF2F2),
                            onTap: () => _handleReset(context),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
