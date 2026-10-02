import 'package:flutter/material.dart';
import '../../setpoint/widgets/unsaved_changes_dialog.dart';

/// Navigation guard dan proteksi unsaved changes untuk halaman Kalibrasi Sensor
class CalibrationProtection {
  CalibrationProtection._();

  static bool Function()? _checkHasUnsavedChanges;
  static VoidCallback? _onDiscard;
  static VoidCallback? _onSave;

  /// Registrasi screen saat aktif
  static void register({
    required bool Function() hasUnsavedChanges,
    required VoidCallback onDiscard,
    required VoidCallback onSave,
  }) {
    _checkHasUnsavedChanges = hasUnsavedChanges;
    _onDiscard = onDiscard;
    _onSave = onSave;
  }

  /// Deregistrasi saat screen di-dispose
  static void unregister() {
    _checkHasUnsavedChanges = null;
    _onDiscard = null;
    _onSave = null;
  }

  /// Cek status unsaved changes
  static bool get hasUnsavedChanges =>
      _checkHasUnsavedChanges?.call() ?? false;

  /// Discard draft
  static void discard() {
    _onDiscard?.call();
  }

  /// Save draft
  static void save() {
    _onSave?.call();
  }

  /// Menampilkan dialog konfirmasi unsaved changes saat user hendak bernavigasi meninggalkan Kalibrasi Sensor.
  static Future<bool> confirmNavigation(BuildContext context) async {
    if (!hasUnsavedChanges) return true;

    final result = await showDialog<UnsavedChangesAction>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const UnsavedChangesDialog(),
    );

    switch (result) {
      case UnsavedChangesAction.save:
        save();
        return true;
      case UnsavedChangesAction.discard:
        discard();
        return true;
      case UnsavedChangesAction.stay:
      case null:
        return false;
    }
  }
}
