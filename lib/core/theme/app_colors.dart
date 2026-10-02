import 'package:flutter/material.dart';

/// Palet warna terpusat sesuai dengan desain sistem Germination Chamber
class AppColors {
  AppColors._();

  // Primary Brand Colors (Forest / Emerald Green)
  static const Color primary = Color(0xFF00853E); 
  static const Color primaryLight = Color(0xFF34A853);
  static const Color primaryDark = Color(0xFF00632E);
  static const Color primaryContainer = Color(0xFFE8F5E9);

  // Secondary & Accents
  static const Color secondary = Color(0xFF0284C7); // Humidity Blue
  static const Color secondaryLight = Color(0xFF38BDF8);
  static const Color secondaryDark = Color(0xFF0369A1);

  // Status & Badges
  static const Color systemStatusGreen = Color(0xFF006830);
  static const Color success = Color(0xFF00853E);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF0284C7);

  // Light Mode Colors
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200
  static const Color lightBorderSubtle = Color(0xFFE5E7EB); // Gray 200
  static const Color lightTextPrimary = Color(0xFF1E293B); // Slate 800
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500
  static const Color lightTextMuted = Color(0xFF94A3B8); // Slate 400

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Sidebar Specific Colors
  static const Color sidebarBackground = Color(0xFF00853E);
  static const Color sidebarActiveItem = Color(0x28FFFFFF); // semi-transparent white
  static const Color sidebarTextActive = Color(0xFFFFFFFF);
  static const Color sidebarTextInactive = Color(0xCCFFFFFF);
  static const Color sidebarDivider = Color(0x33FFFFFF);
}
