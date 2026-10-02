import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Aksi pilihan pada dialog konfirmasi unsaved changes
enum UnsavedChangesAction {
  stay,
  discard,
  save,
}

/// Dialog konfirmasi perlindungan navigasi saat ada perubahan yang belum disimpan
class UnsavedChangesDialog extends StatelessWidget {
  const UnsavedChangesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.lightBorder, width: 1.0),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 22),
          SizedBox(width: 8),
          Text(
            'Unsaved changes',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You have unsaved changes. What would you like to do?',
            style: TextStyle(
              fontSize: 13.5,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      actions: [
        // Tertiary: Stay
        TextButton(
          key: const Key('dialog_stay_here_btn'),
          onPressed: () => Navigator.of(context).pop(UnsavedChangesAction.stay),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.lightTextSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
          child: const Text(
            'Stay',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Secondary: Discard
        OutlinedButton(
          key: const Key('dialog_discard_btn'),
          onPressed: () =>
              Navigator.of(context).pop(UnsavedChangesAction.discard),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.lightTextPrimary,
            side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'Discard',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Primary: Apply
        ElevatedButton(
          key: const Key('dialog_save_btn'),
          onPressed: () => Navigator.of(context).pop(UnsavedChangesAction.save),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'Apply',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
