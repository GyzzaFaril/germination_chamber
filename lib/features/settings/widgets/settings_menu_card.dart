import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

/// Card horizontal interaktif untuk menu di halaman utama Pengaturan
class SettingsMenuCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  const SettingsMenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.iconBackgroundColor,
  });

  @override
  State<SettingsMenuCard> createState() => _SettingsMenuCardState();
}

class _SettingsMenuCardState extends State<SettingsMenuCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = widget.iconColor ?? AppColors.primary;
    final effectiveIconBg =
        widget.iconBackgroundColor ?? const Color(0xFFF0FDF4); // Subtle green tint

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderMd,
          side: BorderSide(
            color: _isHovered ? const Color(0xFFCBD5E1) : AppColors.lightBorder,
            width: 1.0,
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: AppRadius.borderMd,
          hoverColor: Colors.transparent,
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Icon di sisi kiri dengan container melengkung lembut
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: effectiveIconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    widget.icon,
                    size: 22,
                    color: effectiveIconColor,
                  ),
                ),

                const SizedBox(width: 16),

                // Title dan Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Chevron Right
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: _isHovered
                      ? AppColors.primary
                      : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
