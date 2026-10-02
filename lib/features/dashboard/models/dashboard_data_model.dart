/// Model data untuk informasi sensor suhu & kelembapan
class SensorMetric {
  final String title;
  final String tag;
  final double temperature;
  final int humidity;
  final String? statusLabel;

  const SensorMetric({
    required this.title,
    required this.tag,
    required this.temperature,
    required this.humidity,
    this.statusLabel,
  });
}

/// Model data untuk aktuator / perangkat chamber
class ActuatorDevice {
  final String name;
  final String description;
  final String stateText;
  final String modeText;
  final bool isActive;
  final bool hasIcon;

  const ActuatorDevice({
    required this.name,
    required this.description,
    required this.stateText,
    required this.modeText,
    this.isActive = true,
    this.hasIcon = false,
  });
}

/// Model agregat untuk seluruh data Dashboard Germination Chamber
class DashboardDataModel {
  final String timeText;
  final String dateText;
  final String systemState;
  final String systemMode;
  final String subheaderText;
  final SensorMetric sensor1;
  final SensorMetric sensor2;
  final SensorMetric roomAverage;
  final int lightLux;
  final String lightStatus;
  final List<ActuatorDevice> actuators;
  final int waterLevelPercent;
  final String waterLevelStatus;
  final String waterLevelSubtitle;
  final String lightConditionSubtitle;

  const DashboardDataModel({
    required this.timeText,
    required this.dateText,
    required this.systemState,
    required this.systemMode,
    required this.subheaderText,
    required this.sensor1,
    required this.sensor2,
    required this.roomAverage,
    required this.lightLux,
    required this.lightStatus,
    required this.actuators,
    required this.waterLevelPercent,
    required this.waterLevelStatus,
    required this.waterLevelSubtitle,
    required this.lightConditionSubtitle,
  });
}
