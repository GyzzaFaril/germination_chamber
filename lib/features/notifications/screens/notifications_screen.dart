import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_context.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/alarm_event.dart';
import '../widgets/alarm_event_card.dart';
import '../widgets/alarm_summary_card.dart';

/// Screen utama untuk modul Alarm & Notifikasi
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List<AlarmEvent> _events = AlarmEvent.initialEvents;

  List<AlarmEvent> get _filteredEvents {
    switch (_selectedFilter) {
      case 'Critical':
        return _events.where((e) => e.level == AlarmLevel.critical).toList();
      case 'Warning':
        return _events.where((e) => e.level == AlarmLevel.warning).toList();
      case 'Info':
        return _events.where((e) => e.level == AlarmLevel.info).toList();
      case 'All':
      default:
        return _events;
    }
  }

  int get _criticalCount =>
      _events.where((e) => e.level == AlarmLevel.critical).length;

  int get _warningCount =>
      _events.where((e) => e.level == AlarmLevel.warning).length;

  int get _infoCount =>
      _events.where((e) => e.level == AlarmLevel.info).length;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final displayedEvents = _filteredEvents;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Konsisten
            _buildHeader(context),

            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.lightBorder,
            ),

            // 2. Konten Utama: Summary Bar + Event List
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 28.0 : 16.0,
                vertical: isDesktop ? 22.0 : 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Bar
                  AlarmSummaryCard(
                    totalCount: displayedEvents.length,
                    criticalCount: _criticalCount,
                    warningCount: _warningCount,
                    infoCount: _infoCount,
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),

                  const SizedBox(height: 14),

                  // Daftar Event Card
                  if (displayedEvents.isEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      alignment: Alignment.center,
                      child: Text(
                        'Tidak ada kejadian untuk kategori $_selectedFilter',
                        style: const TextStyle(
                          color: AppColors.lightTextMuted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ] else ...[
                    for (int i = 0; i < displayedEvents.length; i++) ...[
                      AlarmEventCard(event: displayedEvents[i]),
                      if (i < displayedEvents.length - 1)
                        const SizedBox(height: 12),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header Alarm & Notifikasi yang konsisten dengan halaman lain
  Widget _buildHeader(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 28.0 : 16.0,
        vertical: 18.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Judul & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alarm & Notifikasi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Events, warnings and system notifications',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Waktu & Tanggal
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '14:32',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '26 Apr 2025',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.lightTextSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
