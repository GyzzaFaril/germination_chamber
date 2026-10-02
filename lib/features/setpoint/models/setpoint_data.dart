/// Data model untuk seluruh parameter Setpoint
class SetpointData {
  final double tempSetpoint;
  final double tempUpper;
  final double tempLower;

  final int humiditySetpoint;
  final int humidityUpper;
  final int humidityLower;

  final int lightSetpoint;
  final int lightUpper;
  final int lightLower;

  final int intakeFanSpeed;
  final int exhaustFanSpeed;

  final int blowerDelay;
  final int mistOff;

  const SetpointData({
    required this.tempSetpoint,
    required this.tempUpper,
    required this.tempLower,
    required this.humiditySetpoint,
    required this.humidityUpper,
    required this.humidityLower,
    required this.lightSetpoint,
    required this.lightUpper,
    required this.lightLower,
    required this.intakeFanSpeed,
    required this.exhaustFanSpeed,
    required this.blowerDelay,
    required this.mistOff,
  });

  /// Nilai awal default sesuai desain sistem dan Figma
  factory SetpointData.initial() => const SetpointData(
        tempSetpoint: 28.0,
        tempUpper: 30.0,
        tempLower: 26.0,
        humiditySetpoint: 85,
        humidityUpper: 90,
        humidityLower: 80,
        lightSetpoint: 7000,
        lightUpper: 8000,
        lightLower: 6000,
        intakeFanSpeed: 60,
        exhaustFanSpeed: 50,
        blowerDelay: 60,
        mistOff: 50,
      );

  SetpointData copyWith({
    double? tempSetpoint,
    double? tempUpper,
    double? tempLower,
    int? humiditySetpoint,
    int? humidityUpper,
    int? humidityLower,
    int? lightSetpoint,
    int? lightUpper,
    int? lightLower,
    int? intakeFanSpeed,
    int? exhaustFanSpeed,
    int? blowerDelay,
    int? mistOff,
  }) {
    return SetpointData(
      tempSetpoint: tempSetpoint ?? this.tempSetpoint,
      tempUpper: tempUpper ?? this.tempUpper,
      tempLower: tempLower ?? this.tempLower,
      humiditySetpoint: humiditySetpoint ?? this.humiditySetpoint,
      humidityUpper: humidityUpper ?? this.humidityUpper,
      humidityLower: humidityLower ?? this.humidityLower,
      lightSetpoint: lightSetpoint ?? this.lightSetpoint,
      lightUpper: lightUpper ?? this.lightUpper,
      lightLower: lightLower ?? this.lightLower,
      intakeFanSpeed: intakeFanSpeed ?? this.intakeFanSpeed,
      exhaustFanSpeed: exhaustFanSpeed ?? this.exhaustFanSpeed,
      blowerDelay: blowerDelay ?? this.blowerDelay,
      mistOff: mistOff ?? this.mistOff,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SetpointData &&
        (other.tempSetpoint - tempSetpoint).abs() < 0.001 &&
        (other.tempUpper - tempUpper).abs() < 0.001 &&
        (other.tempLower - tempLower).abs() < 0.001 &&
        other.humiditySetpoint == humiditySetpoint &&
        other.humidityUpper == humidityUpper &&
        other.humidityLower == humidityLower &&
        other.lightSetpoint == lightSetpoint &&
        other.lightUpper == lightUpper &&
        other.lightLower == lightLower &&
        other.intakeFanSpeed == intakeFanSpeed &&
        other.exhaustFanSpeed == exhaustFanSpeed &&
        other.blowerDelay == blowerDelay &&
        other.mistOff == mistOff;
  }

  @override
  int get hashCode => Object.hash(
        (tempSetpoint * 10).round(),
        (tempUpper * 10).round(),
        (tempLower * 10).round(),
        humiditySetpoint,
        humidityUpper,
        humidityLower,
        lightSetpoint,
        lightUpper,
        lightLower,
        intakeFanSpeed,
        exhaustFanSpeed,
        blowerDelay,
        mistOff,
      );
}
