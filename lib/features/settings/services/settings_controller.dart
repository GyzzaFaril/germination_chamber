import 'package:flutter/material.dart';
import '../models/app_settings_data.dart';
import '../models/sensor_calibration_data.dart';

/// Centralized state controller for application settings
class SettingsController extends ChangeNotifier {
  SettingsController._();

  static final SettingsController instance = SettingsController._();

  AppSettingsData _settings = AppSettingsData.initial();

  AppSettingsData get settings => _settings;

  ThemeMode get themeMode => _settings.themeMode;
  AppDensity get density => _settings.density;
  bool get animationsEnabled => _settings.animationsEnabled;
  String get languageCode => _settings.languageCode;
  bool get useSystemTime => _settings.useSystemTime;
  bool get is24HourFormat => _settings.is24HourFormat;
  DateTime get selectedDate => _settings.selectedDate;
  TimeOfDay get selectedTime => _settings.selectedTime;
  String get timezone => _settings.timezone;
  SensorCalibrationData get calibration => _settings.calibration;

  void updateThemeMode(ThemeMode mode) {
    if (_settings.themeMode == mode) return;
    _settings = _settings.copyWith(themeMode: mode);
    notifyListeners();
  }

  void updateDensity(AppDensity density) {
    if (_settings.density == density) return;
    _settings = _settings.copyWith(density: density);
    notifyListeners();
  }

  void updateAnimationsEnabled(bool enabled) {
    if (_settings.animationsEnabled == enabled) return;
    _settings = _settings.copyWith(animationsEnabled: enabled);
    notifyListeners();
  }

  void updateLanguage(String code) {
    if (_settings.languageCode == code) return;
    _settings = _settings.copyWith(languageCode: code);
    notifyListeners();
  }

  void updateDateTime({
    bool? useSystemTime,
    bool? is24HourFormat,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    String? timezone,
  }) {
    _settings = _settings.copyWith(
      useSystemTime: useSystemTime,
      is24HourFormat: is24HourFormat,
      selectedDate: selectedDate,
      selectedTime: selectedTime,
      timezone: timezone,
    );
    notifyListeners();
  }

  void updateCalibration(SensorCalibrationData calibration) {
    _settings = _settings.copyWith(calibration: calibration);
    notifyListeners();
  }

  void resetToDefault() {
    _settings = AppSettingsData.initial();
    notifyListeners();
  }
}
