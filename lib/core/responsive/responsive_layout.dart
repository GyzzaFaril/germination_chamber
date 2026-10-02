import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Widget helper untuk membangun UI yang berbeda sesuai ukuran layar
class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.tablet) {
          if (desktop != null) {
            return desktop!(context);
          }
          if (tablet != null) {
            return tablet!(context);
          }
        } else if (constraints.maxWidth >= AppBreakpoints.mobile) {
          if (tablet != null) {
            return tablet!(context);
          }
        }
        return mobile(context);
      },
    );
  }
}
