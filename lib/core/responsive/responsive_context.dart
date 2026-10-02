import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Extension pada BuildContext untuk memudahkan pengecekan tipe device / ukuran layar
extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  bool get isMobile => screenWidth < AppBreakpoints.mobile;
  bool get isTablet =>
      screenWidth >= AppBreakpoints.mobile &&
      screenWidth < AppBreakpoints.tablet;
  bool get isDesktop => screenWidth >= AppBreakpoints.tablet;

  /// True jika platform saat ini desktop (lebar tablet ke atas)
  bool get isLargeScreen => screenWidth >= AppBreakpoints.tablet;
}
