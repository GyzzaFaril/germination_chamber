import 'package:flutter/widgets.dart';

/// Sistem token radius sudut komponen UI
class AppRadius {
  AppRadius._();

  static const double none = 0.0;
  static const double sm = 6.0;
  static const double md = 10.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double circular = 999.0;

  // BorderRadius Helpers
  static const BorderRadius borderNone = BorderRadius.zero;
  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderCircular = BorderRadius.all(Radius.circular(circular));
}
