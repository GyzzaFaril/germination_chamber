import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import 'device_fan_painter.dart';
import 'fan_slider_control.dart';

/// Tipe kontrol untuk perangkat aktuator
enum DeviceControlType {
  toggle, // Untuk Mist Maker & Blower (ON / OFF)
  slider, // Untuk Intake Fan & Exhaust Fan (0 - 100%)
}

/// Card horizontal untuk setiap perangkat aktuator dengan layout kolom terstruktur:
/// [ ICON ] [ DEVICE INFORMATION ] [ VALUE ] [ MODE ] [ MANUAL CONTROL ]
class DeviceControlCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isMistMaker;
  final bool isAutoMode;
  final String statusText;
  final DeviceControlType controlType;

  // Props untuk Toggle (Mist Maker & Blower)
  final bool isOn;
  final ValueChanged<bool>? onToggleChanged;

  // Props untuk Slider (Intake Fan & Exhaust Fan)
  final int fanSpeed;
  final ValueChanged<int>? onFanSpeedChanged;

  // Mode Auto/Manual switch callback
  final ValueChanged<bool>? onModeToggle;

  const DeviceControlCard({
    super.key,
    required this.title,
    required this.description,
    this.isMistMaker = false,
    required this.isAutoMode,
    required this.statusText,
    required this.controlType,
    this.isOn = true,
    this.onToggleChanged,
    this.fanSpeed = 0,
    this.onFanSpeedChanged,
    this.onModeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.lightBorder, width: 1.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 650;

          final iconWidget = _buildIcon();

          final titleWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          );

          // Kolom VALUE dengan fixed width agar rata vertikal
          final isOff = statusText == 'OFF';
          final valueWidget = SizedBox(
            width: 70,
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isOff ? const Color(0xFF64748B) : AppColors.primary,
              ),
            ),
          );

          // Kolom MODE dengan fixed width
          final pillsWidget = SizedBox(
            width: 170,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPill(
                  title: 'Auto',
                  isActive: isAutoMode,
                  onTap: () => onModeToggle?.call(true),
                ),
                const SizedBox(width: 8),
                _buildPill(
                  title: 'Manual',
                  isActive: !isAutoMode,
                  onTap: () => onModeToggle?.call(false),
                ),
              ],
            ),
          );

          // Kolom MANUAL CONTROL (hanya tampil jika MANUAL)
          final manualControlWidget = SizedBox(
            width: 230,
            child: isAutoMode
                ? const SizedBox.shrink()
                : (controlType == DeviceControlType.toggle
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: _buildToggleSwitch(),
                      )
                    : FanSliderControl(
                        deviceTitle: title,
                        value: fanSpeed,
                        onChanged: (val) => onFanSpeedChanged?.call(val),
                      )),
          );

          if (isNarrow) {
            return Column(
              children: [
                Row(
                  children: [
                    iconWidget,
                    const SizedBox(width: 14),
                    Expanded(child: titleWidget),
                    valueWidget,
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    pillsWidget,
                    if (!isAutoMode) manualControlWidget,
                  ],
                ),
              ],
            );
          }

          // Desktop: Layout 5 kolom terstruktur dan sejajar vertikal
          return Row(
            children: [
              iconWidget,
              const SizedBox(width: 16),
              Expanded(child: titleWidget),
              const SizedBox(width: 16),
              valueWidget,
              const SizedBox(width: 20),
              pillsWidget,
              const SizedBox(width: 20),
              manualControlWidget,
            ],
          );
        },
      ),
    );
  }

  Widget _buildIcon() {
    if (isMistMaker) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2FE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.air,
          size: 26,
          color: Color(0xFF0284C7),
        ),
      );
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightBorder, width: 1.0),
      ),
      child: const Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CustomPaint(
            painter: DeviceFanPainter(color: AppColors.lightTextPrimary),
          ),
        ),
      ),
    );
  }

  Widget _buildPill({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final bgColor = isActive ? AppColors.primary : const Color(0xFFE8F5E9);
    final textColor = isActive ? Colors.white : const Color(0xFF166534);

    return InkWell(
      key: Key('${this.title}_pill_$title'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  /// Toggle Switch ON/OFF yang aktif hanya saat MANUAL
  Widget _buildToggleSwitch() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('toggle_$title'),
        onTap: () => onToggleChanged?.call(!isOn),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 76,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isOn ? AppColors.primary : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOn ? AppColors.primaryDark : const Color(0xFFCBD5E1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: isOn
                ? [
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        'ON',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ]
                : [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF94A3B8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Text(
                        'OFF',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
