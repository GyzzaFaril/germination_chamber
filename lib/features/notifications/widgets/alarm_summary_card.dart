import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Card ringkas horizontal untuk menampilkan ringkasan jumlah event dan dropdown filter
class AlarmSummaryCard extends StatelessWidget {
  final int totalCount;
  final int criticalCount;
  final int warningCount;
  final int infoCount;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const AlarmSummaryCard({
    super.key,
    required this.totalCount,
    required this.criticalCount,
    required this.warningCount,
    required this.infoCount,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  String _buildSummaryBreakdown() {
    if (selectedFilter == 'Critical') {
      return '$criticalCount critical';
    } else if (selectedFilter == 'Warning') {
      return '$warningCount warnings';
    } else if (selectedFilter == 'Info') {
      return '$infoCount info';
    }
    // Filter == 'All'
    return '$warningCount warnings • $criticalCount critical • $infoCount info';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderMd,
        border: Border.all(
          color: AppColors.lightBorder,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Sisi Kiri: Jumlah Event & Breakdown Detail
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 4,
              children: [
                Text(
                  totalCount == 1 ? '1 event' : '$totalCount events',
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  _buildSummaryBreakdown(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // Sisi Kanan: Dropdown Filter "Filter: All"
          Theme(
            data: Theme.of(context).copyWith(
              hoverColor: const Color(0xFFF8FAFC),
              highlightColor: const Color(0xFFF0FDF4),
              popupMenuTheme: PopupMenuThemeData(
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Color(0xFFE2E8F0),
                    width: 1.0,
                  ),
                ),
                elevation: 4,
                shadowColor: Colors.black.withValues(alpha: 0.08),
                textStyle: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            child: PopupMenuButton<String>(
              key: const Key('alarm_filter_dropdown'),
              initialValue: selectedFilter,
              onSelected: onFilterChanged,
              offset: const Offset(0, 38),
              constraints: const BoxConstraints(
                minWidth: 150,
                maxWidth: 170,
              ),
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Color(0xFFE2E8F0),
                  width: 1.0,
                ),
              ),
              itemBuilder: (context) => [
                _buildMenuItem(
                  value: 'All',
                  label: 'All',
                  key: const Key('filter_option_all'),
                ),
                _buildMenuItem(
                  value: 'Critical',
                  label: 'Critical',
                  key: const Key('filter_option_critical'),
                ),
                _buildMenuItem(
                  value: 'Warning',
                  label: 'Warning',
                  key: const Key('filter_option_warning'),
                ),
                _buildMenuItem(
                  value: 'Info',
                  label: 'Info',
                  key: const Key('filter_option_info'),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // Slate 100 soft
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Filter: $selectedFilter',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B), // Dark navy
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AppColors.lightTextSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required String label,
    required Key key,
  }) {
    final isSelected = selectedFilter == value;

    return PopupMenuItem<String>(
      key: key,
      value: value,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0FDF4) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : const Color(0xFF1E293B), // Dark navy
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_rounded,
                size: 16,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
