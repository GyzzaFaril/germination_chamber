import 'package:flutter/material.dart';
import 'sensor_calibration_data.dart';

/// Opsi kerapatan tampilan (UI Density)
enum AppDensity {
  comfortable('Comfortable', 'Tampilan lapang dengan padding ekstra'),
  standard('Standard', 'Kerapatan seimbang optimal untuk desktop'),
  compact('Compact', 'Tampilan ringkas untuk memaksimalkan area data');

  final String label;
  final String description;
  const AppDensity(this.label, this.description);
}

/// Data konfigurasi pengaturan aplikasi
class AppSettingsData {
  final ThemeMode themeMode;
  final AppDensity density;
  final bool animationsEnabled;
  final String languageCode;
  final bool useSystemTime;
  final bool is24HourFormat;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String timezone;
  final SensorCalibrationData calibration;

  const AppSettingsData({
    required this.themeMode,
    required this.density,
    required this.animationsEnabled,
    required this.languageCode,
    required this.useSystemTime,
    required this.is24HourFormat,
    required this.selectedDate,
    required this.selectedTime,
    required this.timezone,
    required this.calibration,
  });

  /// Konfigurasi default aplikasi
  factory AppSettingsData.initial() {
    return AppSettingsData(
      themeMode: ThemeMode.system,
      density: AppDensity.standard,
      animationsEnabled: true,
      languageCode: 'id',
      useSystemTime: true,
      is24HourFormat: true,
      selectedDate: DateTime(2025, 4, 26),
      selectedTime: const TimeOfDay(hour: 14, minute: 32),
      timezone: 'Asia/Jakarta (WIB)',
      calibration: SensorCalibrationData.initial(),
    );
  }

  AppSettingsData copyWith({
    ThemeMode? themeMode,
    AppDensity? density,
    bool? animationsEnabled,
    String? languageCode,
    bool? useSystemTime,
    bool? is24HourFormat,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    String? timezone,
    SensorCalibrationData? calibration,
  }) {
    return AppSettingsData(
      themeMode: themeMode ?? this.themeMode,
      density: density ?? this.density,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      languageCode: languageCode ?? this.languageCode,
      useSystemTime: useSystemTime ?? this.useSystemTime,
      is24HourFormat: is24HourFormat ?? this.is24HourFormat,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      timezone: timezone ?? this.timezone,
      calibration: calibration ?? this.calibration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingsData &&
        other.themeMode == themeMode &&
        other.density == density &&
        other.animationsEnabled == animationsEnabled &&
        other.languageCode == languageCode &&
        other.useSystemTime == useSystemTime &&
        other.is24HourFormat == is24HourFormat &&
        other.selectedDate == selectedDate &&
        other.selectedTime.hour == selectedTime.hour &&
        other.selectedTime.minute == selectedTime.minute &&
        other.timezone == timezone &&
        other.calibration == calibration;
  }

  @override
  int get hashCode => Object.hash(
        themeMode,
        density,
        animationsEnabled,
        languageCode,
        useSystemTime,
        is24HourFormat,
        selectedDate,
        selectedTime.hour,
        selectedTime.minute,
        timezone,
        calibration,
      );
}
