import 'package:flutter/material.dart';
import '../../core/responsive/responsive_context.dart';
import '../../core/theme/app_colors.dart';
import 'app_sidebar.dart';

/// Shell utama aplikasi yang mengatur navigasi Desktop (Sidebar) dan Mobile (Drawer / Bar)
class MainShell extends StatelessWidget {
  final Widget child;
  final String location;

  const MainShell({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    // Pada Windows Desktop dan layar lebar (>= 768px), sidebar hijau selalu ditampilkan
    final isDesktop = context.screenWidth >= 768;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            // Sidebar Hijau Khas Desain Germination Chamber
            AppSidebar(currentLocation: location),

            // Konten Utama di Sebelah Kanan Sidebar
            Expanded(child: child),
          ],
        ),
      );
    }

    // Tampilan Layar Sempit (< 768px)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.energy_savings_leaf, size: 24, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'GERMINATION CHAMBER',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: AppSidebar(currentLocation: location),
      ),
      body: child,
    );
  }
}
