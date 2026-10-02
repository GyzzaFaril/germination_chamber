import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/responsive/responsive_context.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../services/settings_controller.dart';
import '../widgets/settings_header.dart';

/// Sub-page untuk pemilihan Bahasa aplikasi
class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

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
              title: 'Language',
              subtitle: 'Choose application language',
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
                      final currentLang =
                          SettingsController.instance.languageCode;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Application Language',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Select your preferred language for the user interface',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Opsi 1: Bahasa Indonesia
                          _buildLanguageOptionCard(
                            key: const Key('lang_option_id'),
                            code: 'id',
                            title: 'Bahasa Indonesia',
                            subtitle: 'Bahasa baku sistem & dokumentasi lokal',
                            flag: '🇮🇩',
                            isSelected: currentLang == 'id',
                            onTap: () {
                              SettingsController.instance.updateLanguage('id');
                            },
                          ),

                          const SizedBox(height: 12),

                          // Opsi 2: English
                          _buildLanguageOptionCard(
                            key: const Key('lang_option_en'),
                            code: 'en',
                            title: 'English',
                            subtitle: 'Global standard technical interface',
                            flag: '🇬🇧',
                            isSelected: currentLang == 'en',
                            onTap: () {
                              SettingsController.instance.updateLanguage('en');
                            },
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

  Widget _buildLanguageOptionCard({
    required Key key,
    required String code,
    required String title,
    required String subtitle,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Flag emoji / container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  flag,
                  style: const TextStyle(fontSize: 22),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.lightTextPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (code == 'id') ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 22,
                color: isSelected ? AppColors.primary : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
