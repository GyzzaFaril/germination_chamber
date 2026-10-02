import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_context.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../models/dashboard_data_model.dart';
import '../services/dashboard_service.dart';
import '../widgets/device_status_card.dart';
import '../widgets/light_condition_card.dart';
import '../widgets/light_metric_card.dart';
import '../widgets/sensor_metric_card.dart';
import '../widgets/system_banner_card.dart';
import '../widgets/water_level_card.dart';

/// Screen utama Dashboard Germination Chamber sesuai desain Figma
class DashboardScreen extends StatelessWidget {
  final DashboardDataModel data;

  const DashboardScreen({
    super.key,
    this.data = DashboardService.mockData,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Bagian Atas
            _buildHeader(context),

            const Divider(height: 1, thickness: 1, color: AppColors.lightBorder),

            // 2. Konten Utama Dashboard
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 28.0 : 16.0,
                vertical: isDesktop ? 22.0 : 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subheader Row: Deskripsi & System Status Badge
                  _buildSubHeader(context),

                  const SizedBox(height: 22),

                  // Baris 4 Sensor Cards
                  _buildSensorCardsRow(context),

                  const SizedBox(height: 20),

                  // Baris Status Perangkat & Water/Light Cards
                  _buildMiddleSection(context),

                  const SizedBox(height: 20),

                  // Banner Hijau di Bagian Bawah
                  const SystemBannerCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header Dashboard dengan Jam & Tanggal
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
          // Judul & Subtitle Dashboard
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Overview kondisi chamber dan perangkat secara realtime',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Waktu & Tanggal (Kanan Atas)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.timeText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.dateText,
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

  /// Sub-Header dengan Status Badge "NORMAL • AUTO"
  Widget _buildSubHeader(BuildContext context) {
    final isDesktop = context.isDesktop;

    final textWidget = Text(
      data.subheaderText,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.lightTextPrimary,
        height: 1.4,
      ),
    );

    final badgeWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.systemStatusGreen,
        borderRadius: AppRadius.borderSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'SYSTEM STATUS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF86EFAC),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${data.systemState} • ${data.systemMode}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          badgeWidget,
          const SizedBox(height: 12),
          textWidget,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: textWidget),
        const SizedBox(width: 20),
        badgeWidget,
      ],
    );
  }

  /// 4 Card Sensor di Baris Pertama
  Widget _buildSensorCardsRow(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Desktop lebar: 4 kolom berjajar
    if (screenWidth >= 1150) {
      return Row(
        children: [
          Expanded(child: SensorMetricCard(metric: data.sensor1)),
          const SizedBox(width: 14),
          Expanded(child: SensorMetricCard(metric: data.sensor2)),
          const SizedBox(width: 14),
          Expanded(child: SensorMetricCard(metric: data.roomAverage)),
          const SizedBox(width: 14),
          Expanded(
            child: LightMetricCard(
              lux: data.lightLux,
              status: data.lightStatus,
            ),
          ),
        ],
      );
    }

    // Tablet atau layar medium: 2x2 grid
    if (screenWidth >= 700) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: SensorMetricCard(metric: data.sensor1)),
              const SizedBox(width: 12),
              Expanded(child: SensorMetricCard(metric: data.sensor2)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: SensorMetricCard(metric: data.roomAverage)),
              const SizedBox(width: 12),
              Expanded(
                child: LightMetricCard(
                  lux: data.lightLux,
                  status: data.lightStatus,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Mobile / layar kecil: single column stacked
    return Column(
      children: [
        SensorMetricCard(metric: data.sensor1),
        const SizedBox(height: 10),
        SensorMetricCard(metric: data.sensor2),
        const SizedBox(height: 10),
        SensorMetricCard(metric: data.roomAverage),
        const SizedBox(height: 10),
        LightMetricCard(
          lux: data.lightLux,
          status: data.lightStatus,
        ),
      ],
    );
  }

  /// Bagian Tengah: Status Perangkat (Kiri) & Water Level + Kondisi Cahaya (Kanan)
  Widget _buildMiddleSection(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1050;

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kiri: Status Perangkat (Lebar ~ 65%)
          Expanded(
            flex: 5,
            child: DeviceStatusCard(actuators: data.actuators),
          ),
          const SizedBox(width: 16),

          // Kanan: Water Level & Kondisi Cahaya (Lebar ~ 35%)
          Expanded(
            flex: 2,
            child: Column(
              children: [
                WaterLevelCard(
                  percentage: data.waterLevelPercent,
                  status: data.waterLevelStatus,
                  subtitle: data.waterLevelSubtitle,
                ),
                const SizedBox(height: 14),
                LightConditionCard(
                  lux: data.lightLux,
                  status: data.lightStatus,
                  subtitle: data.lightConditionSubtitle,
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Tampilan Mobile/Tablet: Ditumpuk vertikal
    return Column(
      children: [
        DeviceStatusCard(actuators: data.actuators),
        const SizedBox(height: 14),
        WaterLevelCard(
          percentage: data.waterLevelPercent,
          status: data.waterLevelStatus,
          subtitle: data.waterLevelSubtitle,
        ),
        const SizedBox(height: 14),
        LightConditionCard(
          lux: data.lightLux,
          status: data.lightStatus,
          subtitle: data.lightConditionSubtitle,
        ),
      ],
    );
  }
}
