import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/monitoring_data.dart';

/// Card tabel ringkas untuk riwayat pembacaan sensor terbaru
class LatestReadingsTableCard extends StatelessWidget {
  final List<SensorReadingRow> readings;

  const LatestReadingsTableCard({
    super.key,
    required this.readings,
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
                Icons.table_chart_outlined,
                size: 20,
                color: AppColors.lightTextPrimary,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Sensor Readings',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Most recent data from all sensors',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Tabel Responsif
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      const Color(0xFFF8FAFC),
                    ),
                    horizontalMargin: 16,
                    columnSpacing: 28,
                    headingRowHeight: 40,
                    dataRowMinHeight: 38,
                    dataRowMaxHeight: 42,
                    dividerThickness: 1.0,
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: AppColors.lightBorder.withValues(alpha: 0.6),
                        width: 1.0,
                      ),
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Waktu',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Temperature (°C)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Kelembapan (%RH)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Cahaya (lux)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Water Level (%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                    rows: readings.map((row) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              row.time,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              row.temperature,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              row.humidity,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              row.light,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              row.waterLevel,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
