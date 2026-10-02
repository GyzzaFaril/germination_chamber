import '../models/dashboard_data_model.dart';

/// Service untuk menyediakan data Dashboard (Dummy/Mock sesuai desain Figma)
class DashboardService {
  static const DashboardDataModel mockData = DashboardDataModel(
    timeText: '14:32',
    dateText: '26 Apr 2025',
    systemState: 'NORMAL',
    systemMode: 'AUTO',
    subheaderText: 'Sistem memantau kondisi ruang dan menjaga parameter secara otomatis.',
    sensor1: SensorMetric(
      title: 'Sensor 1',
      tag: 'Atas',
      temperature: 27.8,
      humidity: 85,
      statusLabel: 'Sensor aktif',
    ),
    sensor2: SensorMetric(
      title: 'Sensor 2',
      tag: 'Bawah',
      temperature: 28.3,
      humidity: 82,
      statusLabel: null,
    ),
    roomAverage: SensorMetric(
      title: 'Rata-rata Ruang',
      tag: 'Gabungan Sensor',
      temperature: 28.1,
      humidity: 83,
      statusLabel: 'Kondisi ruang',
    ),
    lightLux: 420,
    lightStatus: 'Normal',
    actuators: [
      ActuatorDevice(
        name: 'Mist Maker',
        description: 'Menghasilkan kabut',
        stateText: 'ON',
        modeText: 'AUTO',
        isActive: true,
        hasIcon: true,
      ),
      ActuatorDevice(
        name: 'Blower',
        description: 'Sirkulasi udara',
        stateText: 'ON',
        modeText: 'AUTO',
        isActive: true,
        hasIcon: false,
      ),
      ActuatorDevice(
        name: 'Intake Fan',
        description: 'Udara masuk',
        stateText: '60 %',
        modeText: 'AUTO',
        isActive: true,
        hasIcon: false,
      ),
      ActuatorDevice(
        name: 'Exhaust Fan',
        description: 'Udara keluar',
        stateText: '50 %',
        modeText: 'AUTO',
        isActive: true,
        hasIcon: false,
      ),
    ],
    waterLevelPercent: 80,
    waterLevelStatus: 'Normal',
    waterLevelSubtitle: 'Bak air / Mist Maker',
    lightConditionSubtitle: 'Sensor cahaya aktif',
  );

  Future<DashboardDataModel> getDashboardData() async {
    return mockData;
  }
}
