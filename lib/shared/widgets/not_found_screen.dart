import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'app_button.dart';

/// Halaman 404 ketika rute tidak ditemukan
class NotFoundScreen extends StatelessWidget {
  final String? path;

  const NotFoundScreen({super.key, this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingAllLg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.redAccent,
              ),
              AppSpacing.verticalMd,
              const Text(
                '404 - Halaman Tidak Ditemukan',
                style: AppTypography.headlineLarge,
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalSm,
              Text(
                path != null ? 'Rute "$path" tidak terdaftar.' : 'Rute yang Anda tuju tidak tersedia.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalLg,
              AppButton(
                text: 'Kembali ke Dashboard',
                icon: Icons.dashboard_rounded,
                onPressed: () => context.go(AppRoutes.dashboard),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
