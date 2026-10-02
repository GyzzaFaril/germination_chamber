import 'package:flutter/material.dart';

/// Fondasi lokalisasi yang scalable untuk mendukung multi-bahasa di masa mendatang
class AppLocale {
  AppLocale._();

  static const Locale indonesian = Locale('id');
  static const Locale english = Locale('en');

  static const List<Locale> supportedLocales = [
    indonesian,
    english,
  ];

  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'id':
      default:
        return 'Bahasa Indonesia';
    }
  }
}
