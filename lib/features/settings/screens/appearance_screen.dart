import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/responsive/responsive_context.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/app_settings_data.dart';
import '../services/settings_controller.dart';
import '../widgets/settings_header.dart';

/// Sub-page untuk konfigurasi Tampilan (Theme, Kerapatan UI / Density, dan Animasi)
class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

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
              title: 'Appearance',
              subtitle: 'Customize application appearance',
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
                  child: ListenableBuilder(
                    listenable: SettingsController.instance,
                    builder: (context, _) {
                      final settings = SettingsController.instance.settings;
                      final currentTheme = settings.themeMode;
                      final currentDensity = settings.density;
                      final animationsEnabled = settings.animationsEnabled;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. SECTION: THEME MODE
                          const Text(
                            'Theme',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Choose overall theme palette for the application',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                child: _buildSelectableCard<ThemeMode>(
                                  key: const Key('theme_option_light'),
                                  value: ThemeMode.light,
                                  selectedValue: currentTheme,
                                  title: 'Light',
                                  subtitle: 'Bright & clean daytime appearance',
                                  icon: Icons.light_mode_rounded,
                                  onSelected: (mode) {
                                    SettingsController.instance
                                        .updateThemeMode(mode);
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildSelectableCard<ThemeMode>(
                                  key: const Key('theme_option_dark'),
                                  value: ThemeMode.dark,
                                  selectedValue: currentTheme,
                                  title: 'Dark',
                                  subtitle: 'Dark appearance, reduces eye strain',
                                  icon: Icons.dark_mode_rounded,
                                  onSelected: (mode) {
                                    SettingsController.instance
                                        .updateThemeMode(mode);
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildSelectableCard<ThemeMode>(
                                  key: const Key('theme_option_system'),
                                  value: ThemeMode.system,
                                  selectedValue: currentTheme,
                                  title: 'System',
                                  subtitle: 'Match operating system preference',
                                  icon: Icons.settings_brightness_rounded,
                                  onSelected: (mode) {
                                    SettingsController.instance
                                        .updateThemeMode(mode);
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // 2. SECTION: DENSITY
                          const Text(
                            'Density',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Control the spacing and compactness of UI elements',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                child: _buildSelectableCard<AppDensity>(
                                  key: const Key('density_option_comfortable'),
                                  value: AppDensity.comfortable,
                                  selectedValue: currentDensity,
                                  title: 'Comfortable',
                                  subtitle: 'Extra padding & relaxed spacing',
                                  icon: Icons.view_comfortable_rounded,
                                  onSelected: (density) {
                                    SettingsController.instance
                                        .updateDensity(density);
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildSelectableCard<AppDensity>(
                                  key: const Key('density_option_standard'),
                                  value: AppDensity.standard,
                                  selectedValue: currentDensity,
                                  title: 'Standard',
                                  subtitle: 'Balanced desktop layout (default)',
                                  icon: Icons.view_compact_alt_rounded,
                                  onSelected: (density) {
                                    SettingsController.instance
                                        .updateDensity(density);
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _buildSelectableCard<AppDensity>(
                                  key: const Key('density_option_compact'),
                                  value: AppDensity.compact,
                                  selectedValue: currentDensity,
                                  title: 'Compact',
                                  subtitle: 'Maximum data density on screen',
                                  icon: Icons.view_headline_rounded,
                                  onSelected: (density) {
                                    SettingsController.instance
                                        .updateDensity(density);
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // 3. SECTION: ANIMATIONS
                          const Text(
                            'Animation',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Control motion effects throughout the application',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 14),

                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppRadius.borderMd,
                              border: Border.all(
                                color: AppColors.lightBorder,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDF4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.animation_rounded,
                                    size: 22,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Interface animations',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightTextPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Enable smooth transitions, hover effects, and micro-animations',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Switch(
                                  key: const Key('switch_interface_animations'),
                                  value: animationsEnabled,
                                  activeTrackColor: AppColors.primary,
                                  onChanged: (val) {
                                    SettingsController.instance
                                        .updateAnimationsEnabled(val);
                                  },
                                ),
                              ],
                            ),
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

  Widget _buildSelectableCard<T>({
    required Key key,
    required T value,
    required T selectedValue,
    required String title,
    required String subtitle,
    required IconData icon,
    required ValueChanged<T> onSelected,
  }) {
    final isSelected = value == selectedValue;

    return Material(
      color: isSelected ? const Color(0xFFF0FDF4) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderMd,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.lightBorder,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        key: key,
        onTap: () => onSelected(value),
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      size: 20,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 20,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.lightTextMuted,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.lightTextSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
