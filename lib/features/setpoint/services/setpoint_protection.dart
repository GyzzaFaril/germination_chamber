import 'package:flutter/material.dart';
import '../models/setpoint_data.dart';
import '../widgets/unsaved_changes_dialog.dart';

/// Service singleton / registry untuk Navigation Guard dan manajemen proteksi perubahan yang belum disimpan
class SetpointProtection {
  SetpointProtection._();

  // Saved data persisten selama siklus hidup aplikasi
  static SetpointData savedData = SetpointData.initial();

  // Active screen callbacks
  static bool Function()? _checkHasUnsavedChanges;
  static VoidCallback? _onDiscard;
  static VoidCallback? _onSave;

  /// Registrasi screen Setpoint saat aktif
  static void register({
    required bool Function() hasUnsavedChanges,
    required VoidCallback onDiscard,
    required VoidCallback onSave,
  }) {
    _checkHasUnsavedChanges = hasUnsavedChanges;
    _onDiscard = onDiscard;
    _onSave = onSave;
  }

  /// Deregistrasi saat screen Setpoint di-dispose
  static void unregister() {
    _checkHasUnsavedChanges = null;
    _onDiscard = null;
    _onSave = null;
  }

  /// Apakah terdapat perubahan yang belum disimpan di halaman Setpoint
  static bool get hasUnsavedChanges =>
      _checkHasUnsavedChanges?.call() ?? false;

  /// Eksekusi discard perubahan draft
  static void discard() {
    _onDiscard?.call();
  }

  /// Eksekusi simpan perubahan draft
  static void save() {
    _onSave?.call();
  }

  /// Menampilkan dialog konfirmasi unsaved changes saat user hendak bernavigasi meninggalkan Setpoint.
  /// Mengembalikan `true` jika navigasi diizinkan untuk dilanjutkan, atau `false` jika user memilih 'Stay here'.
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
