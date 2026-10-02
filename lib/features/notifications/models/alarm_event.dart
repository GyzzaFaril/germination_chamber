import 'package:flutter/material.dart';

/// Tingkat keparahan event alarm
enum AlarmLevel {
  critical,
  warning,
  info;

  String get label {
    switch (this) {
      case AlarmLevel.critical:
        return 'CRITICAL';
      case AlarmLevel.warning:
        return 'WARNING';
      case AlarmLevel.info:
        return 'INFO';
    }
  }

  Color get color {
    switch (this) {
      case AlarmLevel.critical:
        return const Color(0xFFDC2626); // Merah
      case AlarmLevel.warning:
        return const Color(0xFFD97706); // Amber / Orange
      case AlarmLevel.info:
        return const Color(0xFF475569); // Slate netral / Navy
    }
  }
}

/// Model data event alarm & notifikasi
class AlarmEvent {
  final String id;
  final AlarmLevel level;
  final String title;
  final String description;
  final String time;

  const AlarmEvent({
    required this.id,
    required this.level,
    required this.title,
    required this.description,
    required this.time,
  });

  /// Mock data awal sesuai desain referensi Figma (7 events: 2 warnings, 1 critical, 4 info)
  static const List<AlarmEvent> initialEvents = [
    AlarmEvent(
      id: 'alarm_1',
      level: AlarmLevel.critical,
      title: 'Suhu terlalu tinggi',
      description: 'Temperature exceeded upper limit',
      time: '10:15',
    ),
    AlarmEvent(
      id: 'alarm_2',
      level: AlarmLevel.warning,
      title: 'Water level rendah',
      description: 'Water level is below safe threshold',
      time: '11:23',
    ),
    AlarmEvent(
      id: 'alarm_3',
      level: AlarmLevel.warning,
      title: 'Kelembapan terlalu rendah',
      description: 'RH is below configured setpoint',
      time: '09:20',
    ),
    AlarmEvent(
      id: 'alarm_4',
      level: AlarmLevel.info,
      title: 'Selisih sensor normal',
      description: 'Sensor difference returned to normal',
      time: '08:45',
    ),
    AlarmEvent(
      id: 'alarm_5',
      level: AlarmLevel.info,
      title: 'Mist Maker OFF',
      description: 'Humidity reached target',
      time: '08:10',
    ),
    AlarmEvent(
      id: 'alarm_6',
      level: AlarmLevel.info,
      title: 'Blower ON',
      description: 'Air circulation routine started',
      time: '07:30',
    ),
    AlarmEvent(
      id: 'alarm_7',
      level: AlarmLevel.info,
      title: 'System reboot completed',
      description: 'All sensor nodes reconnected',
      time: '06:00',
    ),
  ];
}
