import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_context.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/monitoring_data.dart';
import '../widgets/chamber_status_card.dart';
import '../widgets/current_sensor_card.dart';
import '../widgets/latest_readings_table_card.dart';
import '../widgets/monitoring_chart_card.dart';
import '../widgets/telemetry_line_chart.dart';

/// Screen utama untuk modul Monitoring
class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  String _tempHumidityPeriod = '6H';
  String _lightPeriod = '6H';
  String _waterLevelPeriod = '6H';

  String _formatSubtitle(String period) {
    switch (period) {
      case '1H':
        return 'Last 1 hour';
      case '24H':
        return 'Last 24 hours';
      case '7D':
        return 'Last 7 days';
      case '6H':
      default:
        return 'Last 6 hours';
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
            // 1. Header
            _buildHeader(context),

            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.lightBorder,
            ),

            // 2. Konten Utama Monitoring
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 28.0 : 16.0,
                vertical: isDesktop ? 22.0 : 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HIERARKI 1: Current Sensor Values (4 Cards)
                  _buildCurrentSensorCards(isDesktop),

                  const SizedBox(height: 18),

                  // HIERARKI 2: Temperature & Kelembapan + Cahaya Charts
                  if (isDesktop)
                    _buildChartsRowDesktop()
                  else
                    _buildChartsColumnMobile(),

                  const SizedBox(height: 18),

                  // HIERARKI 3: Water Level Chart + Chamber Status
                  if (isDesktop)
                    _buildWaterAndStatusRowDesktop()
                  else
                    _buildWaterAndStatusColumnMobile(),

                  const SizedBox(height: 18),

                  // HIERARKI 4: Latest Sensor Readings (Tabel Full Width)
                  const LatestReadingsTableCard(
                    readings: MonitoringData.latestReadings,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header Monitoring yang konsisten dengan halaman Setpoint dan Kontrol Perangkat
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
                  'Monitoring',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Realtime environmental telemetry',
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

  /// 4 Current Sensor Cards (Horizontal Row di Desktop, 2x2 atau Column di Mobile)
  Widget _buildCurrentSensorCards(bool isDesktop) {
    const cardTemp = CurrentSensorCard(
      label: 'Temperature',
      value: '28.1',
      unit: '°C',
      status: 'Within range',
      icon: Icons.thermostat_outlined,
      iconColor: AppColors.primary,
    );

    const cardHumidity = CurrentSensorCard(
      label: 'Kelembapan',
      value: '83',
      unit: '%RH',
      status: 'Within range',
      icon: Icons.water_drop,
      iconColor: Color(0xFF0284C7),
    );

    const cardLight = CurrentSensorCard(
      label: 'Cahaya',
      value: '7420',
      unit: 'lux',
      status: 'Within range',
      icon: Icons.light_mode_outlined,
      iconColor: Color(0xFFD97706),
    );

    const cardWater = CurrentSensorCard(
      label: 'Water Level',
      value: '80',
      unit: '%',
      status: 'Normal',
      icon: Icons.water,
      iconColor: Color(0xFF0284C7),
    );

    if (isDesktop) {
      return const Row(
        children: [
          Expanded(child: cardTemp),
          SizedBox(width: 14),
          Expanded(child: cardHumidity),
          SizedBox(width: 14),
          Expanded(child: cardLight),
          SizedBox(width: 14),
          Expanded(child: cardWater),
        ],
      );
    } else {
      return const Column(
        children: [
          Row(
            children: [
              Expanded(child: cardTemp),
              SizedBox(width: 12),
              Expanded(child: cardHumidity),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: cardLight),
              SizedBox(width: 12),
              Expanded(child: cardWater),
            ],
          ),
        ],
      );
    }
  }

  /// Grafik Baris 1 Desktop: Temperature & Kelembapan + Cahaya
  Widget _buildChartsRowDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildTempHumidityChartCard()),
        const SizedBox(width: 18),
        Expanded(child: _buildLightChartCard()),
      ],
    );
  }

  /// Grafik Baris 1 Mobile: Kolom bertumpuk
  Widget _buildChartsColumnMobile() {
    return Column(
      children: [
        _buildTempHumidityChartCard(),
        const SizedBox(height: 14),
        _buildLightChartCard(),
      ],
    );
  }

  /// Grafik Baris 2 Desktop: Water Level + Chamber Status
  Widget _buildWaterAndStatusRowDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildWaterLevelChartCard()),
        const SizedBox(width: 18),
        const Expanded(child: ChamberStatusCard()),
      ],
    );
  }

  /// Grafik Baris 2 Mobile: Kolom bertumpuk
  Widget _buildWaterAndStatusColumnMobile() {
    return Column(
      children: [
        _buildWaterLevelChartCard(),
        const SizedBox(height: 14),
        const ChamberStatusCard(),
      ],
    );
  }

  /// Card 1: Grafik Temperature & Kelembapan
  Widget _buildTempHumidityChartCard() {
    final points = MonitoringData.getTelemetryPoints(_tempHumidityPeriod);
    final timeLabels = points.map((p) => p.timeLabel).toList();
    final tempValues = points.map((p) => p.temperature).toList();
    final humidityValues = points.map((p) => p.humidity).toList();

    return MonitoringChartCard(
      title: 'Temperature & Kelembapan',
      subtitle: _formatSubtitle(_tempHumidityPeriod),
      selectedPeriod: _tempHumidityPeriod,
      onPeriodChanged: (period) {
        setState(() {
          _tempHumidityPeriod = period;
        });
      },
      legends: [
        _buildLegendItem(
          color: AppColors.primary,
          label: 'Temperature (°C)',
        ),
        const SizedBox(width: 16),
        _buildLegendItem(
          color: const Color(0xFF0284C7),
          label: 'Kelembapan (%RH)',
        ),
      ],
      chart: TelemetryLineChart(
        timeLabels: timeLabels,
        values1: tempValues,
        color1: AppColors.primary,
        min1: 25.0,
        max1: 30.0,
        values2: humidityValues,
        color2: const Color(0xFF0284C7),
        min2: 75.0,
        max2: 95.0,
        height: 150,
      ),
    );
  }

  /// Card 2: Grafik Cahaya
  Widget _buildLightChartCard() {
    final points = MonitoringData.getTelemetryPoints(_lightPeriod);
    final timeLabels = points.map((p) => p.timeLabel).toList();
    final lightValues = points.map((p) => p.light).toList();

    return MonitoringChartCard(
      title: 'Cahaya',
      subtitle: _formatSubtitle(_lightPeriod),
      selectedPeriod: _lightPeriod,
      onPeriodChanged: (period) {
        setState(() {
          _lightPeriod = period;
        });
      },
      legends: [
        _buildLegendItem(
          color: const Color(0xFFD97706),
          label: 'Light (lux)',
        ),
        const SizedBox(width: 16),
        _buildLegendItem(
          color: const Color(0xFF94A3B8),
          label: 'Setpoint (7000 lux)',
          isDashed: true,
        ),
      ],
      chart: TelemetryLineChart(
        timeLabels: timeLabels,
        values1: lightValues,
        color1: const Color(0xFFD97706),
        min1: 5000.0,
        max1: 9000.0,
        dashedYValue: 7000.0,
        dashedColor: const Color(0xFF94A3B8),
        height: 150,
      ),
    );
  }

  /// Card 3: Grafik Water Level
  Widget _buildWaterLevelChartCard() {
    final points = MonitoringData.getTelemetryPoints(_waterLevelPeriod);
    final timeLabels = points.map((p) => p.timeLabel).toList();
    final waterValues = points.map((p) => p.waterLevel).toList();

    return MonitoringChartCard(
      title: 'Water Level',
      subtitle: _formatSubtitle(_waterLevelPeriod),
      selectedPeriod: _waterLevelPeriod,
      onPeriodChanged: (period) {
        setState(() {
          _waterLevelPeriod = period;
        });
      },
      legends: [
        _buildLegendItem(
          color: const Color(0xFF0284C7),
          label: 'Water Level (%)',
        ),
        const SizedBox(width: 16),
        _buildLegendItem(
          color: const Color(0xFF94A3B8),
          label: 'Target (80 %)',
          isDashed: true,
        ),
      ],
      chart: TelemetryLineChart(
        timeLabels: timeLabels,
        values1: waterValues,
        color1: const Color(0xFF0284C7),
        min1: 60.0,
        max1: 100.0,
        dashedYValue: 80.0,
        dashedColor: const Color(0xFF94A3B8),
        height: 150,
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    bool isDashed = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isDashed) ...[
          Container(
            width: 14,
            height: 2,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ] else ...[
          Icon(
            Icons.circle,
            size: 7,
            color: color,
          ),
        ],
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
