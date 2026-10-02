/// Data model untuk offset kalibrasi sensor dan nilai pembacaan sensor saat ini
class SensorCalibrationData {
  final double tempReading;
  final double tempOffset;

  final double humidityReading;
  final double humidityOffset;

  final int lightReading;
  final int lightOffset;

  final double waterLevelReading;
  final double waterLevelOffset;

  const SensorCalibrationData({
    required this.tempReading,
    required this.tempOffset,
    required this.humidityReading,
    required this.humidityOffset,
    required this.lightReading,
    required this.lightOffset,
    required this.waterLevelReading,
    required this.waterLevelOffset,
  });

  /// Factory data awal / default
  factory SensorCalibrationData.initial() {
    return const SensorCalibrationData(
      tempReading: 24.5,
      tempOffset: 0.0,
      humidityReading: 68.0,
      humidityOffset: 0.0,
      lightReading: 7500,
      lightOffset: 0,
      waterLevelReading: 85.0,
      waterLevelOffset: 0.0,
    );
  }

  SensorCalibrationData copyWith({
    double? tempReading,
    double? tempOffset,
    double? humidityReading,
    double? humidityOffset,
    int? lightReading,
    int? lightOffset,
    double? waterLevelReading,
    double? waterLevelOffset,
  }) {
    return SensorCalibrationData(
      tempReading: tempReading ?? this.tempReading,
      tempOffset: tempOffset ?? this.tempOffset,
      humidityReading: humidityReading ?? this.humidityReading,
      humidityOffset: humidityOffset ?? this.humidityOffset,
      lightReading: lightReading ?? this.lightReading,
      lightOffset: lightOffset ?? this.lightOffset,
      waterLevelReading: waterLevelReading ?? this.waterLevelReading,
      waterLevelOffset: waterLevelOffset ?? this.waterLevelOffset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SensorCalibrationData &&
        (other.tempOffset - tempOffset).abs() < 0.01 &&
        (other.humidityOffset - humidityOffset).abs() < 0.01 &&
        other.lightOffset == lightOffset &&
        (other.waterLevelOffset - waterLevelOffset).abs() < 0.01;
  }

  @override
  int get hashCode => Object.hash(
        tempOffset.toStringAsFixed(1),
        humidityOffset.toStringAsFixed(1),
        lightOffset,
        waterLevelOffset.toStringAsFixed(1),
      );
}
