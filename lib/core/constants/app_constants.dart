/// Aplikasi konstanta umum
class AppConstants {
  AppConstants._();

  static const String appName = 'Flutter Desktop & Mobile App';
  static const String appVersion = '1.0.0';

  // Konfigurasi endpoint backend NestJS untuk tahap integrasi masa depan
  // Menggunakan localhost untuk Windows Desktop dan 10.0.2.2 untuk Android Emulator
  static const String baseApiUrlAndroid = 'http://10.0.2.2:3000/api/v1';
  static const String baseApiUrlWindows = 'http://localhost:3000/api/v1';

  // Timeout konfigurasi HTTP
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Pagination default
  static const int defaultPageSize = 20;
}
