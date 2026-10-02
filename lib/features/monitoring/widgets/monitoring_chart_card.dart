import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Card grafik telemetri dengan header judul, filter rentang waktu, dan legend
class MonitoringChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;
  final List<Widget> legends;
  final Widget chart;

  const MonitoringChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.legends,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    const periods = ['1H', '6H', '24H', '7D'];

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
          // Header: Judul & Filter Periode
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Filter Waktu 1H | 6H | 24H | 7D
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // Slate 100
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(2.5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: periods.map((p) {
                    final isSelected = p == selectedPeriod;
                    return InkWell(
                      key: Key('period_filter_${title.toLowerCase().replaceAll(' ', '_')}_$p'),
                      onTap: () => onPeriodChanged(p),
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          p,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? AppColors.lightTextPrimary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Legend Row
          Row(
            children: legends,
          ),

          const SizedBox(height: 14),

          // Area Grafik
          chart,
        ],
      ),
    );
  }
}
