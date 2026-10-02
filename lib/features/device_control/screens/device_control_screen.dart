import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_context.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/device_mode.dart';
import '../widgets/device_control_card.dart';
import '../widgets/device_notice_card.dart';
import '../widgets/operating_mode_selector.dart';
import '../widgets/water_level_control_card.dart';

/// Screen utama untuk modul Kontrol Perangkat dengan dukungan Global Mode, Individual Device Mode,
/// Kolom Value sejajar vertikal, Toggle ON/OFF (hanya saat MANUAL), dan Input Numerik + Slider (hanya saat MANUAL).
class DeviceControlScreen extends StatefulWidget {
  const DeviceControlScreen({super.key});

  @override
  State<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  // State mode independen untuk masing-masing perangkat
  DeviceMode _mistMakerMode = DeviceMode.auto;
  DeviceMode _blowerMode = DeviceMode.auto;
  DeviceMode _intakeFanMode = DeviceMode.auto;
  DeviceMode _exhaustFanMode = DeviceMode.auto;

  // Local state untuk nilai kontrol masing-masing aktuator
  bool _mistMakerOn = true;
  bool _blowerOn = false; // Blower default OFF sesuai contoh
  int _intakeFanSpeed = 41; // Sesuai contoh pada spesifikasi terbaru: 41 %
  int _exhaustFanSpeed = 51; // Sesuai contoh pada spesifikasi terbaru: 51 %

  // Status agregasi global mode
  bool get _isAllAuto =>
      _mistMakerMode == DeviceMode.auto &&
      _blowerMode == DeviceMode.auto &&
      _intakeFanMode == DeviceMode.auto &&
      _exhaustFanMode == DeviceMode.auto;

  bool get _isAllManual =>
      _mistMakerMode == DeviceMode.manual &&
      _blowerMode == DeviceMode.manual &&
      _intakeFanMode == DeviceMode.manual &&
      _exhaustFanMode == DeviceMode.manual;

  /// Global Mass Control: Ubah semua perangkat menjadi AUTO
  void _setAllAuto() {
    setState(() {
      _mistMakerMode = DeviceMode.auto;
      _blowerMode = DeviceMode.auto;
      _intakeFanMode = DeviceMode.auto;
      _exhaustFanMode = DeviceMode.auto;
    });
  }

  /// Global Mass Control: Ubah semua perangkat menjadi MANUAL
  void _setAllManual() {
    setState(() {
      _mistMakerMode = DeviceMode.manual;
      _blowerMode = DeviceMode.manual;
      _intakeFanMode = DeviceMode.manual;
      _exhaustFanMode = DeviceMode.manual;
    });
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
            // 1. Header Bagian Atas
            _buildHeader(context),

            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.lightBorder,
            ),

            // 2. Konten Utama Kontrol Perangkat
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 28.0 : 16.0,
                vertical: isDesktop ? 22.0 : 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Global Operating Mode Selector (Mass Control)
                  OperatingModeSelector(
                    isAllAuto: _isAllAuto,
                    isAllManual: _isAllManual,
                    onSetAllAuto: _setAllAuto,
                    onSetAllManual: _setAllManual,
                  ),

                  const SizedBox(height: 16),

                  // 1. Mist Maker (Toggle Switch ON/OFF, hanya tampil saat MANUAL)
                  DeviceControlCard(
                    title: 'Mist Maker',
                    description: 'Produces humidity',
                    isMistMaker: true,
                    isAutoMode: _mistMakerMode == DeviceMode.auto,
                    statusText: _mistMakerOn ? 'ON' : 'OFF',
                    controlType: DeviceControlType.toggle,
                    isOn: _mistMakerOn,
                    onToggleChanged: (val) {
                      setState(() {
                        _mistMakerOn = val;
                      });
                    },
                    onModeToggle: (isAuto) {
                      setState(() {
                        _mistMakerMode =
                            isAuto ? DeviceMode.auto : DeviceMode.manual;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // 2. Blower (Toggle Switch ON/OFF, hanya tampil saat MANUAL)
                  DeviceControlCard(
                    title: 'Blower',
                    description: 'Chamber circulation',
                    isMistMaker: false,
                    isAutoMode: _blowerMode == DeviceMode.auto,
                    statusText: _blowerOn ? 'ON' : 'OFF',
                    controlType: DeviceControlType.toggle,
                    isOn: _blowerOn,
                    onToggleChanged: (val) {
                      setState(() {
                        _blowerOn = val;
                      });
                    },
                    onModeToggle: (isAuto) {
                      setState(() {
                        _blowerMode =
                            isAuto ? DeviceMode.auto : DeviceMode.manual;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // 3. Intake Fan (Input Numerik + Slider, hanya tampil saat MANUAL)
                  DeviceControlCard(
                    title: 'Intake Fan',
                    description: 'Fresh air intake',
                    isMistMaker: false,
                    isAutoMode: _intakeFanMode == DeviceMode.auto,
                    statusText: '$_intakeFanSpeed %',
                    controlType: DeviceControlType.slider,
                    fanSpeed: _intakeFanSpeed,
                    onFanSpeedChanged: (val) {
                      setState(() {
                        _intakeFanSpeed = val;
                      });
                    },
                    onModeToggle: (isAuto) {
                      setState(() {
                        _intakeFanMode =
                            isAuto ? DeviceMode.auto : DeviceMode.manual;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // 4. Exhaust Fan (Input Numerik + Slider, hanya tampil saat MANUAL)
                  DeviceControlCard(
                    title: 'Exhaust Fan',
                    description: 'Air outlet',
                    isMistMaker: false,
                    isAutoMode: _exhaustFanMode == DeviceMode.auto,
                    statusText: '$_exhaustFanSpeed %',
                    controlType: DeviceControlType.slider,
                    fanSpeed: _exhaustFanSpeed,
                    onFanSpeedChanged: (val) {
                      setState(() {
                        _exhaustFanSpeed = val;
                      });
                    },
                    onModeToggle: (isAuto) {
                      setState(() {
                        _exhaustFanMode =
                            isAuto ? DeviceMode.auto : DeviceMode.manual;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // 5. Water Level (Monitoring saja, tanpa kontrol manual, value sejajar)
                  const WaterLevelControlCard(
                    title: 'Water Level',
                    description: 'Mist Maker Dijalankan',
                    status: 'Normal',
                    percentage: '80 %',
                  ),

                  const SizedBox(height: 14),

                  // 6. Catatan Card
                  const DeviceNoticeCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header Kontrol Perangkat dengan Subtitle Dinamis, Jam, dan Tanggal
  Widget _buildHeader(BuildContext context) {
    final isDesktop = context.isDesktop;

    String subtitle;
    if (_isAllAuto) {
      subtitle =
          'Automatic actuator control based on sensor values and setpoints';
    } else if (_isAllManual) {
      subtitle = 'Manual control for direct actuator adjustment';
    } else {
      subtitle =
          'Actuator control with customized auto and manual configurations';
    }

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
          // Judul & Subtitle Dinamis Sesuai Status Agregasi Mode
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kontrol Perangkat',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    subtitle,
                    key: ValueKey<String>(subtitle),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.lightTextSecondary,
                      fontSize: 12,
                    ),
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
