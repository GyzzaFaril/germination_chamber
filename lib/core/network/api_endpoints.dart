/// Definisi endpoint REST API NestJS yang akan datang
/// Disesuaikan dengan domain Monitoring, Kontrol Perangkat, Sensor, dan Settings
class ApiEndpoints {
  ApiEndpoints._();

  // Authentication & Session
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';

  // Dashboard & Overview
  static const String dashboardSummary = '/dashboard/summary';

  // Monitoring
  static const String monitoringMetrics = '/monitoring/metrics';
  static const String monitoringLogs = '/monitoring/logs';

  // Kontrol Perangkat (Device Control)
  static const String devices = '/devices';
  static String deviceDetail(String id) => '/devices/$id';
  static String deviceCommand(String id) => '/devices/$id/command';

  // Sensor
  static const String sensors = '/sensors';
  static String sensorDetail(String id) => '/sensors/$id';
  static String sensorTelemetry(String id) => '/sensors/$id/telemetry';

  // Settings
  static const String settings = '/settings';
}
