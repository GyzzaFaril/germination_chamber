import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/responsive/responsive_context.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../services/settings_controller.dart';
import '../widgets/settings_header.dart';

/// Sub-page untuk konfigurasi Tanggal, Waktu, dan Zona Waktu
class DateTimeSettingsScreen extends StatelessWidget {
  const DateTimeSettingsScreen({super.key});

  static const List<String> _timezones = [
    'Asia/Jakarta (WIB)',
    'Asia/Makassar (WITA)',
    'Asia/Jayapura (WIT)',
    'UTC',
  ];

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
              title: 'Date & Time',
              subtitle: 'Configure date, time and timezone',
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
                      final useSystemTime = settings.useSystemTime;
                      final date = settings.selectedDate;
                      final time = settings.selectedTime;
                      final timezone = settings.timezone;

                      const months = [
                        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
                        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
                      ];
                      final dateFormatted =
                          '${date.day} ${months[date.month - 1]} ${date.year}';
                      final timeFormatted =
                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card 1: Pengaturan Sinkronisasi Otomatis
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
                                    color: const Color(0xFFF0F9FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.sync_rounded,
                                    size: 22,
                                    color: Color(0xFF0284C7),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Use system time',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightTextPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Automatically synchronize date and time from the system clock',
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
                                  key: const Key('switch_use_system_time'),
                                  value: useSystemTime,
                                  activeTrackColor: AppColors.primary,
                                  onChanged: (val) {
                                    SettingsController.instance.updateDateTime(
                                      useSystemTime: val,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Card 2: Pengaturan Manual Tanggal & Waktu
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Manual Adjustment',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  useSystemTime
                                      ? 'Disable "Use system time" above to configure manually'
                                      : 'Adjust the system clock manually',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: AppColors.lightTextSecondary,
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // Row Tanggal & Waktu
                                Row(
                                  children: [
                                    // Kolom Tanggal
                                    Expanded(
                                      child: _buildValueTile(
                                        label: 'Date',
                                        value: dateFormatted,
                                        icon: Icons.calendar_today_rounded,
                                        enabled: !useSystemTime,
                                        onTap: () async {
                                          final picked = await showDatePicker(
                                            context: context,
                                            initialDate: date,
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2035),
                                          );
                                          if (picked != null) {
                                            SettingsController.instance
                                                .updateDateTime(
                                              selectedDate: picked,
                                            );
                                          }
                                        },
                                        buttonKey: const Key('btn_change_date'),
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    // Kolom Waktu
                                    Expanded(
                                      child: _buildValueTile(
                                        label: 'Time',
                                        value: timeFormatted,
                                        icon: Icons.access_time_rounded,
                                        enabled: !useSystemTime,
                                        onTap: () async {
                                          final picked = await showTimePicker(
                                            context: context,
                                            initialTime: time,
                                          );
                                          if (picked != null) {
                                            SettingsController.instance
                                                .updateDateTime(
                                              selectedTime: picked,
                                            );
                                          }
                                        },
                                        buttonKey: const Key('btn_change_time'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Card 3: Zona Waktu (Timezone)
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
                                    Icons.public_rounded,
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
                                        'Timezone',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightTextPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Select default regional timezone for logging and schedules',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: const Color(0xFFCBD5E1),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      key: const Key('dropdown_timezone'),
                                      value: timezone,
                                      dropdownColor: Colors.white,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1E293B),
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 18,
                                        color: AppColors.lightTextSecondary,
                                      ),
                                      items: _timezones.map((tz) {
                                        return DropdownMenuItem<String>(
                                          value: tz,
                                          child: Text(tz),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          SettingsController.instance
                                              .updateDateTime(
                                            timezone: val,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Card 4: 24-Hour Format Toggle
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
                                    color: const Color(0xFFF5F3FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.access_time_filled_rounded,
                                    size: 22,
                                    color: Color(0xFF7C3AED),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '24-Hour Format',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.lightTextPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Display time in 24-hour notation (e.g. 14:32)',
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
                                  key: const Key('switch_24_hour_format'),
                                  value: settings.is24HourFormat,
                                  activeTrackColor: AppColors.primary,
                                  onChanged: (val) {
                                    SettingsController.instance.updateDateTime(
                                      is24HourFormat: val,
                                    );
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

  Widget _buildValueTile({
    required String label,
    required String value,
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    required Key buttonKey,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFFF8FAFC) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: enabled ? AppColors.primary : AppColors.lightTextMuted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? AppColors.lightTextPrimary
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            key: buttonKey,
            onPressed: enabled ? onTap : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              side: BorderSide(
                color: enabled
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFFE2E8F0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              'Change',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: enabled
                    ? AppColors.lightTextPrimary
                    : AppColors.lightTextMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
