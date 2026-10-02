import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/responsive/responsive_context.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/sensor_calibration_data.dart';
import '../services/calibration_protection.dart';
import '../services/settings_controller.dart';
import '../widgets/settings_header.dart';

/// Screen untuk melakukan kalibrasi sensor (Temperature, Humidity, Light, Water Level)
class SensorCalibrationScreen extends StatefulWidget {
  const SensorCalibrationScreen({super.key});

  @override
  State<SensorCalibrationScreen> createState() =>
      _SensorCalibrationScreenState();
}

class _SensorCalibrationScreenState extends State<SensorCalibrationScreen> {
  late SensorCalibrationData _savedData;
  late SensorCalibrationData _draftData;

  late final TextEditingController _tempOffsetController;
  late final TextEditingController _humidityOffsetController;
  late final TextEditingController _lightOffsetController;
  late final TextEditingController _waterOffsetController;

  late final FocusNode _tempFocus;
  late final FocusNode _humidityFocus;
  late final FocusNode _lightFocus;
  late final FocusNode _waterFocus;

  bool get hasUnsavedChanges => _draftData != _savedData;

  int get modifiedCount {
    int count = 0;
    if ((_draftData.tempOffset - _savedData.tempOffset).abs() >= 0.05) count++;
    if ((_draftData.humidityOffset - _savedData.humidityOffset).abs() >= 0.05) {
      count++;
    }
    if (_draftData.lightOffset != _savedData.lightOffset) count++;
    if ((_draftData.waterLevelOffset - _savedData.waterLevelOffset).abs() >=
        0.05) {
      count++;
    }
    return count;
  }

  double _round1(double v) => (v * 10).round() / 10.0;

  @override
  void initState() {
    super.initState();
    _savedData = SettingsController.instance.calibration;
    _draftData = _savedData;

    _tempOffsetController = TextEditingController(
      text: _formatOffset(_draftData.tempOffset, isDecimal: true),
    );
    _humidityOffsetController = TextEditingController(
      text: _formatOffset(_draftData.humidityOffset, isDecimal: true),
    );
    _lightOffsetController = TextEditingController(
      text: _draftData.lightOffset >= 0
          ? '+${_draftData.lightOffset}'
          : '${_draftData.lightOffset}',
    );
    _waterOffsetController = TextEditingController(
      text: _formatOffset(_draftData.waterLevelOffset, isDecimal: true),
    );

    _tempFocus = FocusNode();
    _humidityFocus = FocusNode();
    _lightFocus = FocusNode();
    _waterFocus = FocusNode();

    _tempFocus.addListener(() => _handleFocusChange(_tempFocus, _commitTemp));
    _humidityFocus.addListener(
        () => _handleFocusChange(_humidityFocus, _commitHumidity));
    _lightFocus.addListener(() => _handleFocusChange(_lightFocus, _commitLight));
    _waterFocus.addListener(() => _handleFocusChange(_waterFocus, _commitWater));

    CalibrationProtection.register(
      hasUnsavedChanges: () => hasUnsavedChanges,
      onDiscard: _discardChangesSilently,
      onSave: _applyChangesSilently,
    );
  }

  void _handleFocusChange(FocusNode node, VoidCallback commitFn) {
    if (!node.hasFocus) {
      commitFn();
    }
  }

  String _formatOffset(double val, {bool isDecimal = true}) {
    final rounded = _round1(val);
    final sign = rounded > 0 ? '+' : '';
    return isDecimal ? '$sign${rounded.toStringAsFixed(1)}' : '$sign$rounded';
  }

  @override
  void dispose() {
    CalibrationProtection.unregister();
    _tempFocus.dispose();
    _humidityFocus.dispose();
    _lightFocus.dispose();
    _waterFocus.dispose();

    _tempOffsetController.dispose();
    _humidityOffsetController.dispose();
    _lightOffsetController.dispose();
    _waterOffsetController.dispose();
    super.dispose();
  }

  void _commitTemp([String? text]) {
    final raw = (text ?? _tempOffsetController.text).replaceAll('+', '').trim();
    final parsed = double.tryParse(raw);
    if (parsed != null) {
      final clamped = _round1(parsed.clamp(-10.0, 10.0));
      setState(() {
        _draftData = _draftData.copyWith(tempOffset: clamped);
        _tempOffsetController.text =
            _formatOffset(clamped, isDecimal: true);
      });
    } else {
      _tempOffsetController.text =
          _formatOffset(_draftData.tempOffset, isDecimal: true);
    }
  }

  void _commitHumidity([String? text]) {
    final raw =
        (text ?? _humidityOffsetController.text).replaceAll('+', '').trim();
    final parsed = double.tryParse(raw);
    if (parsed != null) {
      final clamped = _round1(parsed.clamp(-20.0, 20.0));
      setState(() {
        _draftData = _draftData.copyWith(humidityOffset: clamped);
        _humidityOffsetController.text =
            _formatOffset(clamped, isDecimal: true);
      });
    } else {
      _humidityOffsetController.text =
          _formatOffset(_draftData.humidityOffset, isDecimal: true);
    }
  }

  void _commitLight([String? text]) {
    final raw =
        (text ?? _lightOffsetController.text).replaceAll('+', '').trim();
    final parsed = int.tryParse(raw);
    if (parsed != null) {
      final clamped = parsed.clamp(-2000, 2000);
      setState(() {
        _draftData = _draftData.copyWith(lightOffset: clamped);
        _lightOffsetController.text =
            clamped >= 0 ? '+$clamped' : '$clamped';
      });
    } else {
      _lightOffsetController.text = _draftData.lightOffset >= 0
          ? '+${_draftData.lightOffset}'
          : '${_draftData.lightOffset}';
    }
  }

  void _commitWater([String? text]) {
    final raw =
        (text ?? _waterOffsetController.text).replaceAll('+', '').trim();
    final parsed = double.tryParse(raw);
    if (parsed != null) {
      final clamped = _round1(parsed.clamp(-20.0, 20.0));
      setState(() {
        _draftData = _draftData.copyWith(waterLevelOffset: clamped);
        _waterOffsetController.text =
            _formatOffset(clamped, isDecimal: true);
      });
    } else {
      _waterOffsetController.text =
          _formatOffset(_draftData.waterLevelOffset, isDecimal: true);
    }
  }

  void _discardChangesSilently() {
    _draftData = _savedData;
    _tempOffsetController.text =
        _formatOffset(_savedData.tempOffset, isDecimal: true);
    _humidityOffsetController.text =
        _formatOffset(_savedData.humidityOffset, isDecimal: true);
    _lightOffsetController.text = _savedData.lightOffset >= 0
        ? '+${_savedData.lightOffset}'
        : '${_savedData.lightOffset}';
    _waterOffsetController.text =
        _formatOffset(_savedData.waterLevelOffset, isDecimal: true);
  }

  void _discardChanges() {
    FocusScope.of(context).unfocus();
    setState(() {
      _discardChangesSilently();
    });
  }

  void _applyChangesSilently() {
    _savedData = _draftData;
    SettingsController.instance.updateCalibration(_savedData);
  }

  void _applyChanges() {
    FocusScope.of(context).unfocus();
    setState(() {
      _applyChangesSilently();
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sensor calibration updated successfully'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleNavigateBack() async {
    if (hasUnsavedChanges) {
      final proceed = await CalibrationProtection.confirmNavigation(context);
      if (proceed && mounted) {
        context.go(AppRoutes.settings);
      }
    } else {
      context.go(AppRoutes.settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final proceed = await CalibrationProtection.confirmNavigation(context);
        if (proceed && context.mounted) {
          context.go(AppRoutes.settings);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan tombol kembali & indikator unsaved changes
              SettingsHeader(
                title: 'Sensor Calibration',
                subtitle:
                    'Adjust sensor readings using calibration offsets',
                onBack: _handleNavigateBack,
                hasUnsavedChanges: hasUnsavedChanges,
                modifiedCount: modifiedCount,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Kalibrasi Temperature
                        _buildSensorCalibrationCard(
                          icon: Icons.thermostat_outlined,
                          iconColor: const Color(0xFFEA580C),
                          iconBg: const Color(0xFFFFF7ED),
                          sensorName: 'Temperature (SHT31)',
                          currentReading:
                              '${_draftData.tempReading.toStringAsFixed(1)} °C',
                          calibratedReading:
                              '${(_draftData.tempReading + _draftData.tempOffset).toStringAsFixed(1)} °C',
                          unit: '°C',
                          controller: _tempOffsetController,
                          focusNode: _tempFocus,
                          onSubmitted: _commitTemp,
                          onDecrement: () {
                            final next = _round1(_draftData.tempOffset - 0.1);
                            if (next >= -10.0) {
                              setState(() {
                                _draftData =
                                    _draftData.copyWith(tempOffset: next);
                                _tempOffsetController.text =
                                    _formatOffset(next, isDecimal: true);
                              });
                            }
                          },
                          onIncrement: () {
                            final next = _round1(_draftData.tempOffset + 0.1);
                            if (next <= 10.0) {
                              setState(() {
                                _draftData =
                                    _draftData.copyWith(tempOffset: next);
                                _tempOffsetController.text =
                                    _formatOffset(next, isDecimal: true);
                              });
                            }
                          },
                          decKey: const Key('temp_offset_dec'),
                          incKey: const Key('temp_offset_inc'),
                          inputKey: const Key('temp_offset_input'),
                        ),

                        const SizedBox(height: 14),

                        // Card Kalibrasi Humidity
                        _buildSensorCalibrationCard(
                          icon: Icons.water_drop_outlined,
                          iconColor: const Color(0xFF0284C7),
                          iconBg: const Color(0xFFF0F9FF),
                          sensorName: 'Humidity (SHT31)',
                          currentReading:
                              '${_draftData.humidityReading.toStringAsFixed(1)} %RH',
                          calibratedReading:
                              '${(_draftData.humidityReading + _draftData.humidityOffset).toStringAsFixed(1)} %RH',
                          unit: '%RH',
                          controller: _humidityOffsetController,
                          focusNode: _humidityFocus,
                          onSubmitted: _commitHumidity,
                          onDecrement: () {
                            final next =
                                _round1(_draftData.humidityOffset - 0.5);
                            if (next >= -20.0) {
                              setState(() {
                                _draftData =
                                    _draftData.copyWith(humidityOffset: next);
                                _humidityOffsetController.text =
                                    _formatOffset(next, isDecimal: true);
                              });
                            }
                          },
                          onIncrement: () {
                            final next =
                                _round1(_draftData.humidityOffset + 0.5);
                            if (next <= 20.0) {
                              setState(() {
                                _draftData =
                                    _draftData.copyWith(humidityOffset: next);
                                _humidityOffsetController.text =
                                    _formatOffset(next, isDecimal: true);
                              });
                            }
                          },
                          decKey: const Key('humidity_offset_dec'),
                          incKey: const Key('humidity_offset_inc'),
                          inputKey: const Key('humidity_offset_input'),
                        ),

                        const SizedBox(height: 14),

                        // Card Kalibrasi Light
                        _buildSensorCalibrationCard(
                          icon: Icons.wb_sunny_outlined,
                          iconColor: const Color(0xFFD97706),
                          iconBg: const Color(0xFFFFFBEB),
                          sensorName: 'Light (BH1750)',
                          currentReading: '${_draftData.lightReading} lux',
                          calibratedReading:
                              '${_draftData.lightReading + _draftData.lightOffset} lux',
                          unit: 'lux',
                          controller: _lightOffsetController,
                          focusNode: _lightFocus,
                          onSubmitted: _commitLight,
                          onDecrement: () {
                            final next = _draftData.lightOffset - 50;
                            if (next >= -2000) {
                              setState(() {
                                _draftData =
                                    _draftData.copyWith(lightOffset: next);
                                _lightOffsetController.text =
                                    next >= 0 ? '+$next' : '$next';
                              });
                            }
                          },
                          onIncrement: () {
                            final next = _draftData.lightOffset + 50;
                            if (next <= 2000) {
                              setState(() {
                                _draftData =
                                    _draftData.copyWith(lightOffset: next);
                                _lightOffsetController.text =
                                    next >= 0 ? '+$next' : '$next';
                              });
                            }
                          },
                          decKey: const Key('light_offset_dec'),
                          incKey: const Key('light_offset_inc'),
                          inputKey: const Key('light_offset_input'),
                        ),

                        const SizedBox(height: 14),

                        // Card Kalibrasi Water Level
                        _buildSensorCalibrationCard(
                          icon: Icons.waves_rounded,
                          iconColor: const Color(0xFF0D9488),
                          iconBg: const Color(0xFFF0FDFA),
                          sensorName: 'Water Level (Contactless)',
                          currentReading:
                              '${_draftData.waterLevelReading.toStringAsFixed(1)} %',
                          calibratedReading:
                              '${(_draftData.waterLevelReading + _draftData.waterLevelOffset).toStringAsFixed(1)} %',
                          unit: '%',
                          controller: _waterOffsetController,
                          focusNode: _waterFocus,
                          onSubmitted: _commitWater,
                          onDecrement: () {
                            final next =
                                _round1(_draftData.waterLevelOffset - 0.5);
                            if (next >= -20.0) {
                              setState(() {
                                _draftData =
                                    _draftData.copyWith(waterLevelOffset: next);
                                _waterOffsetController.text =
                                    _formatOffset(next, isDecimal: true);
                              });
                            }
                          },
                          onIncrement: () {
                            final next =
                                _round1(_draftData.waterLevelOffset + 0.5);
                            if (next <= 20.0) {
                              setState(() {
                                _draftData =
                                    _draftData.copyWith(waterLevelOffset: next);
                                _waterOffsetController.text =
                                    _formatOffset(next, isDecimal: true);
                              });
                            }
                          },
                          decKey: const Key('water_offset_dec'),
                          incKey: const Key('water_offset_inc'),
                          inputKey: const Key('water_offset_input'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: hasUnsavedChanges
            ? _buildStickyActionBar(isDesktop)
            : null,
      ),
    );
  }

  Widget _buildSensorCalibrationCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String sensorName,
    required String currentReading,
    required String calibratedReading,
    required String unit,
    required TextEditingController controller,
    required FocusNode focusNode,
    required ValueChanged<String> onSubmitted,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    required Key decKey,
    required Key incKey,
    required Key inputKey,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Sensor
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 22, color: iconColor),
          ),

          const SizedBox(width: 16),

          // Info Sensor & Current Reading
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  sensorName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Reading: $currentReading',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('•',
                        style: TextStyle(
                            color: AppColors.lightBorder, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text(
                      'Result: $calibratedReading',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Value Box Kalibrasi Offset (Consistent with Setpoint stepper)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tombol Minus (-)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  key: decKey,
                  onTap: onDecrement,
                  borderRadius: BorderRadius.circular(6),
                  hoverColor: const Color(0xFFF1F5F9),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.remove,
                      size: 16,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // Value Box Input (Light gray background & dark navy text)
              Container(
                width: 78,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    selectionColor: AppColors.primary.withValues(alpha: 0.2),
                    selectionHandleColor: AppColors.primary,
                    cursorColor: AppColors.primary,
                  ),
                  child: TextField(
                    key: inputKey,
                    controller: controller,
                    focusNode: focusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: AppColors.primary,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onSubmitted: onSubmitted,
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // Tombol Plus (+)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  key: incKey,
                  onTap: onIncrement,
                  borderRadius: BorderRadius.circular(6),
                  hoverColor: const Color(0xFFF1F5F9),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 16,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Unit
              SizedBox(
                width: 36,
                child: Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStickyActionBar(bool isDesktop) {
    return Container(
      key: const Key('calibration_sticky_action_bar'),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 28.0 : 16.0,
        vertical: 14.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, -3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                modifiedCount > 0
                    ? 'Unsaved changes ($modifiedCount)'
                    : 'Unsaved changes',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                key: const Key('calibration_discard_btn'),
                onPressed: _discardChanges,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.lightTextPrimary,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Discard changes',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                key: const Key('calibration_apply_btn'),
                onPressed: _applyChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Apply changes',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
