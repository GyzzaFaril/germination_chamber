/// Titik data telemetri historis untuk chart monitoring
class TelemetryPoint {
  final String timeLabel;
  final double temperature;
  final double humidity;
  final double light;
  final double lightSetpoint;
  final double waterLevel;

  const TelemetryPoint({
    required this.timeLabel,
    required this.temperature,
    required this.humidity,
    required this.light,
    this.lightSetpoint = 7000.0,
    required this.waterLevel,
  });
}

/// Baris riwayat pembacaan sensor terbaru
class SensorReadingRow {
  final String time;
  final String temperature;
  final String humidity;
  final String light;
  final String waterLevel;

  const SensorReadingRow({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.waterLevel,
  });
}

/// Dataset telemetri lokal / dummy yang realistis untuk monitoring
class MonitoringData {
  MonitoringData._();

  static const List<SensorReadingRow> latestReadings = [
    SensorReadingRow(
      time: '14:30',
      temperature: '28.1',
      humidity: '83',
      light: '7420',
      waterLevel: '80',
    ),
    SensorReadingRow(
      time: '14:20',
      temperature: '28.0',
      humidity: '84',
      light: '7380',
      waterLevel: '80',
    ),
    SensorReadingRow(
      time: '14:10',
      temperature: '27.9',
      humidity: '84',
      light: '7410',
      waterLevel: '81',
    ),
    SensorReadingRow(
      time: '14:00',
      temperature: '27.8',
      humidity: '85',
      light: '7390',
      waterLevel: '80',
    ),
    SensorReadingRow(
      time: '13:50',
      temperature: '27.8',
      humidity: '85',
      light: '7350',
      waterLevel: '79',
    ),
  ];

  static List<TelemetryPoint> getTelemetryPoints(String period) {
    switch (period) {
      case '1H':
        return const [
          TelemetryPoint(
            timeLabel: '13:40',
            temperature: 27.7,
            humidity: 85.5,
            light: 7320,
            waterLevel: 79.0,
          ),
          TelemetryPoint(
            timeLabel: '13:50',
            temperature: 27.8,
            humidity: 85.0,
            light: 7350,
            waterLevel: 79.0,
          ),
          TelemetryPoint(
            timeLabel: '14:00',
            temperature: 27.8,
            humidity: 85.0,
            light: 7390,
            waterLevel: 80.0,
          ),
          TelemetryPoint(
            timeLabel: '14:10',
            temperature: 27.9,
            humidity: 84.0,
            light: 7410,
            waterLevel: 81.0,
          ),
          TelemetryPoint(
            timeLabel: '14:20',
            temperature: 28.0,
            humidity: 84.0,
            light: 7380,
            waterLevel: 80.0,
          ),
          TelemetryPoint(
            timeLabel: '14:30',
            temperature: 28.1,
            humidity: 83.0,
            light: 7420,
            waterLevel: 80.0,
          ),
        ];

      case '24H':
        return const [
          TelemetryPoint(
            timeLabel: '18:00',
            temperature: 27.0,
            humidity: 87.0,
            light: 6500,
            waterLevel: 83.0,
          ),
          TelemetryPoint(
            timeLabel: '22:00',
            temperature: 26.5,
            humidity: 88.0,
            light: 6000,
            waterLevel: 82.5,
          ),
          TelemetryPoint(
            timeLabel: '02:00',
            temperature: 26.2,
            humidity: 89.0,
            light: 6000,
            waterLevel: 82.0,
          ),
          TelemetryPoint(
            timeLabel: '06:00',
            temperature: 26.8,
            humidity: 88.0,
            light: 6800,
            waterLevel: 81.5,
          ),
          TelemetryPoint(
            timeLabel: '10:00',
            temperature: 27.6,
            humidity: 85.0,
            light: 7200,
            waterLevel: 81.0,
          ),
          TelemetryPoint(
            timeLabel: '14:00',
            temperature: 28.1,
            humidity: 83.0,
            light: 7420,
            waterLevel: 80.0,
          ),
        ];

      case '7D':
        return const [
          TelemetryPoint(
            timeLabel: '20 Apr',
            temperature: 27.6,
            humidity: 84.0,
            light: 7100,
            waterLevel: 84.0,
          ),
          TelemetryPoint(
            timeLabel: '21 Apr',
            temperature: 27.8,
            humidity: 83.5,
            light: 7250,
            waterLevel: 83.0,
          ),
          TelemetryPoint(
            timeLabel: '22 Apr',
            temperature: 27.9,
            humidity: 84.2,
            light: 7300,
            waterLevel: 82.0,
          ),
          TelemetryPoint(
            timeLabel: '23 Apr',
            temperature: 28.0,
            humidity: 83.8,
            light: 7400,
            waterLevel: 81.5,
          ),
          TelemetryPoint(
            timeLabel: '24 Apr',
            temperature: 27.8,
            humidity: 84.5,
            light: 7320,
            waterLevel: 81.0,
          ),
          TelemetryPoint(
            timeLabel: '25 Apr',
            temperature: 28.0,
            humidity: 84.0,
            light: 7380,
            waterLevel: 80.5,
          ),
          TelemetryPoint(
            timeLabel: '26 Apr',
            temperature: 28.1,
            humidity: 83.0,
            light: 7420,
            waterLevel: 80.0,
          ),
        ];

      case '6H':
      default:
        return const [
          TelemetryPoint(
            timeLabel: '09:00',
            temperature: 27.2,
            humidity: 86.5,
            light: 6900,
            waterLevel: 82.0,
          ),
          TelemetryPoint(
            timeLabel: '10:00',
            temperature: 27.5,
            humidity: 85.8,
            light: 7100,
            waterLevel: 81.5,
          ),
          TelemetryPoint(
            timeLabel: '11:00',
            temperature: 27.9,
            humidity: 84.2,
            light: 7350,
            waterLevel: 81.0,
          ),
          TelemetryPoint(
            timeLabel: '12:00',
            temperature: 28.2,
            humidity: 83.5,
            light: 7520,
            waterLevel: 80.5,
          ),
          TelemetryPoint(
            timeLabel: '13:00',
            temperature: 28.0,
            humidity: 84.0,
            light: 7380,
            waterLevel: 80.0,
          ),
          TelemetryPoint(
            timeLabel: '14:00',
            temperature: 27.8,
            humidity: 85.0,
            light: 7390,
            waterLevel: 80.0,
          ),
          TelemetryPoint(
            timeLabel: '14:30',
            temperature: 28.1,
            humidity: 83.0,
            light: 7420,
            waterLevel: 80.0,
          ),
        ];
    }
  }
}
