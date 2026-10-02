import 'package:flutter/material.dart';
import '../../../core/responsive/responsive_context.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../device_control/widgets/device_fan_painter.dart';
import '../models/setpoint_data.dart';
import '../services/setpoint_protection.dart';
import '../widgets/automatic_logic_card.dart';
import '../widgets/discard_confirm_dialog.dart';
import '../widgets/setpoint_card.dart';
import '../widgets/setpoint_stepper_row.dart';
import '../widgets/ventilation_defaults_card.dart';

/// Screen utama modul Setpoint dengan dukungan Unsaved Changes Protection
class SetpointScreen extends StatefulWidget {
  const SetpointScreen({super.key});

  @override
  State<SetpointScreen> createState() => _SetpointScreenState();
}

class _SetpointScreenState extends State<SetpointScreen> {
  // Saved State & Draft State
  late SetpointData _savedState;
  late SetpointData _draftState;

  // Saved defaults untuk kartu informasi mode AUTO
  late int _savedIntakeDefault;
  late int _savedExhaustDefault;
  late int _savedBlowerDelaySeconds;

  // Mengecek apakah terdapat perbedaan antara draft state dengan saved state
  bool get hasUnsavedChanges => _draftState != _savedState;

  // Menghitung jumlah parameter yang telah diubah
  int get modifiedParametersCount {
    int count = 0;
    if ((_draftState.tempSetpoint - _savedState.tempSetpoint).abs() >= 0.05) count++;
    if ((_draftState.tempUpper - _savedState.tempUpper).abs() >= 0.05) count++;
    if ((_draftState.tempLower - _savedState.tempLower).abs() >= 0.05) count++;
    if (_draftState.humiditySetpoint != _savedState.humiditySetpoint) count++;
    if (_draftState.humidityUpper != _savedState.humidityUpper) count++;
    if (_draftState.humidityLower != _savedState.humidityLower) count++;
    if (_draftState.lightSetpoint != _savedState.lightSetpoint) count++;
    if (_draftState.lightUpper != _savedState.lightUpper) count++;
    if (_draftState.lightLower != _savedState.lightLower) count++;
    if (_draftState.intakeFanSpeed != _savedState.intakeFanSpeed) count++;
    if (_draftState.exhaustFanSpeed != _savedState.exhaustFanSpeed) count++;
    if (_draftState.blowerDelay != _savedState.blowerDelay) count++;
    if (_draftState.mistOff != _savedState.mistOff) count++;
    return count;
  }

  // Deteksi card yang dimodifikasi
  bool get isTempModified =>
      (_draftState.tempSetpoint - _savedState.tempSetpoint).abs() >= 0.05 ||
      (_draftState.tempUpper - _savedState.tempUpper).abs() >= 0.05 ||
      (_draftState.tempLower - _savedState.tempLower).abs() >= 0.05;

  bool get isHumidityModified =>
      _draftState.humiditySetpoint != _savedState.humiditySetpoint ||
      _draftState.humidityUpper != _savedState.humidityUpper ||
      _draftState.humidityLower != _savedState.humidityLower;

  bool get isLightModified =>
      _draftState.lightSetpoint != _savedState.lightSetpoint ||
      _draftState.lightUpper != _savedState.lightUpper ||
      _draftState.lightLower != _savedState.lightLower;

  bool get isVentilasiModified =>
      _draftState.intakeFanSpeed != _savedState.intakeFanSpeed ||
      _draftState.exhaustFanSpeed != _savedState.exhaustFanSpeed;

  bool get isLainnyaModified =>
      _draftState.blowerDelay != _savedState.blowerDelay ||
      _draftState.mistOff != _savedState.mistOff;

  // Persistent TextEditingControllers
  late final TextEditingController _tempSetpointController;
  late final TextEditingController _tempUpperController;
  late final TextEditingController _tempLowerController;

  late final TextEditingController _humiditySetpointController;
  late final TextEditingController _humidityUpperController;
  late final TextEditingController _humidityLowerController;

  late final TextEditingController _lightSetpointController;
  late final TextEditingController _lightUpperController;
  late final TextEditingController _lightLowerController;

  late final TextEditingController _intakeController;
  late final TextEditingController _exhaustController;

  late final TextEditingController _delayBlowerController;
  late final TextEditingController _mistOffController;

  // Persistent FocusNodes
  late final FocusNode _tempSetpointFocus;
  late final FocusNode _tempUpperFocus;
  late final FocusNode _tempLowerFocus;

  late final FocusNode _humiditySetpointFocus;
  late final FocusNode _humidityUpperFocus;
  late final FocusNode _humidityLowerFocus;

  late final FocusNode _lightSetpointFocus;
  late final FocusNode _lightUpperFocus;
  late final FocusNode _lightLowerFocus;

  late final FocusNode _intakeFocus;
  late final FocusNode _exhaustFocus;

  late final FocusNode _delayBlowerFocus;
  late final FocusNode _mistOffFocus;

  // Helper pembulatan 1 desimal untuk float
  double _round1(double value) => (value * 10).round() / 10.0;

  @override
  void initState() {
    super.initState();
    _savedState = SetpointProtection.savedData;
    _draftState = SetpointProtection.savedData;

    _savedIntakeDefault = _savedState.intakeFanSpeed;
    _savedExhaustDefault = _savedState.exhaustFanSpeed;
    _savedBlowerDelaySeconds = _savedState.blowerDelay;

    _initControllersAndFocus();

    // Daftarkan callback ke SetpointProtection untuk Navigation Guard
    SetpointProtection.register(
      hasUnsavedChanges: () => hasUnsavedChanges,
      onDiscard: _discardChanges,
      onSave: _saveChangesSilently,
    );
  }

  void _initControllersAndFocus() {
    _tempSetpointController =
        TextEditingController(text: _draftState.tempSetpoint.toStringAsFixed(1));
    _tempUpperController =
        TextEditingController(text: _draftState.tempUpper.toStringAsFixed(1));
    _tempLowerController =
        TextEditingController(text: _draftState.tempLower.toStringAsFixed(1));

    _humiditySetpointController =
        TextEditingController(text: _draftState.humiditySetpoint.toString());
    _humidityUpperController =
        TextEditingController(text: _draftState.humidityUpper.toString());
    _humidityLowerController =
        TextEditingController(text: _draftState.humidityLower.toString());

    _lightSetpointController =
        TextEditingController(text: _draftState.lightSetpoint.toString());
    _lightUpperController =
        TextEditingController(text: _draftState.lightUpper.toString());
    _lightLowerController =
        TextEditingController(text: _draftState.lightLower.toString());

    _intakeController =
        TextEditingController(text: _draftState.intakeFanSpeed.toString());
    _exhaustController =
        TextEditingController(text: _draftState.exhaustFanSpeed.toString());

    _delayBlowerController =
        TextEditingController(text: _draftState.blowerDelay.toString());
    _mistOffController =
        TextEditingController(text: _draftState.mistOff.toString());

    _tempSetpointFocus = FocusNode();
    _tempUpperFocus = FocusNode();
    _tempLowerFocus = FocusNode();

    _humiditySetpointFocus = FocusNode();
    _humidityUpperFocus = FocusNode();
    _humidityLowerFocus = FocusNode();

    _lightSetpointFocus = FocusNode();
    _lightUpperFocus = FocusNode();
    _lightLowerFocus = FocusNode();

    _intakeFocus = FocusNode();
    _exhaustFocus = FocusNode();

    _delayBlowerFocus = FocusNode();
    _mistOffFocus = FocusNode();

    // Attach focus loss listeners to commit pending edits
    _attachFocusListener(
      _tempSetpointFocus,
      _tempSetpointController,
      () => _commitTempSetpoint(_tempSetpointController.text),
    );
    _attachFocusListener(
      _tempUpperFocus,
      _tempUpperController,
      () => _commitTempUpper(_tempUpperController.text),
    );
    _attachFocusListener(
      _tempLowerFocus,
      _tempLowerController,
      () => _commitTempLower(_tempLowerController.text),
    );

    _attachFocusListener(
      _humiditySetpointFocus,
      _humiditySetpointController,
      () => _commitHumiditySetpoint(_humiditySetpointController.text),
    );
    _attachFocusListener(
      _humidityUpperFocus,
      _humidityUpperController,
      () => _commitHumidityUpper(_humidityUpperController.text),
    );
    _attachFocusListener(
      _humidityLowerFocus,
      _humidityLowerController,
      () => _commitHumidityLower(_humidityLowerController.text),
    );

    _attachFocusListener(
      _lightSetpointFocus,
      _lightSetpointController,
      () => _commitLightSetpoint(_lightSetpointController.text),
    );
    _attachFocusListener(
      _lightUpperFocus,
      _lightUpperController,
      () => _commitLightUpper(_lightUpperController.text),
    );
    _attachFocusListener(
      _lightLowerFocus,
      _lightLowerController,
      () => _commitLightLower(_lightLowerController.text),
    );

    _attachFocusListener(
      _intakeFocus,
      _intakeController,
      () => _commitIntakeFan(_intakeController.text),
    );
    _attachFocusListener(
      _exhaustFocus,
      _exhaustController,
      () => _commitExhaustFan(_exhaustController.text),
    );

    _attachFocusListener(
      _delayBlowerFocus,
      _delayBlowerController,
      () => _commitDelayBlower(_delayBlowerController.text),
    );
    _attachFocusListener(
      _mistOffFocus,
      _mistOffController,
      () => _commitMistOff(_mistOffController.text),
    );
  }

  void _attachFocusListener(
    FocusNode node,
    TextEditingController controller,
    VoidCallback onCommit,
  ) {
    node.addListener(() {
      if (!node.hasFocus) {
        onCommit();
      } else {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    SetpointProtection.unregister();

    _tempSetpointController.dispose();
    _tempUpperController.dispose();
    _tempLowerController.dispose();

    _humiditySetpointController.dispose();
    _humidityUpperController.dispose();
    _humidityLowerController.dispose();

    _lightSetpointController.dispose();
    _lightUpperController.dispose();
    _lightLowerController.dispose();

    _intakeController.dispose();
    _exhaustController.dispose();

    _delayBlowerController.dispose();
    _mistOffController.dispose();

    _tempSetpointFocus.dispose();
    _tempUpperFocus.dispose();
    _tempLowerFocus.dispose();

    _humiditySetpointFocus.dispose();
    _humidityUpperFocus.dispose();
    _humidityLowerFocus.dispose();

    _lightSetpointFocus.dispose();
    _lightUpperFocus.dispose();
    _lightLowerFocus.dispose();

    _intakeFocus.dispose();
    _exhaustFocus.dispose();

    _delayBlowerFocus.dispose();
    _mistOffFocus.dispose();

    super.dispose();
  }

  // --- Handlers: Keyboard Commit & Clamping ---

  void _commitTempSetpoint(String raw) {
    final parsed = double.tryParse(raw.replaceAll(',', '.'));
    if (parsed == null) {
      _tempSetpointController.text = _draftState.tempSetpoint.toStringAsFixed(1);
      return;
    }
    final clamped = _round1(parsed.clamp(_draftState.tempLower, _draftState.tempUpper));
    setState(() {
      _draftState = _draftState.copyWith(tempSetpoint: clamped);
    });
    _tempSetpointController.text = _draftState.tempSetpoint.toStringAsFixed(1);
  }

  void _commitTempUpper(String raw) {
    final parsed = double.tryParse(raw.replaceAll(',', '.'));
    if (parsed == null) {
      _tempUpperController.text = _draftState.tempUpper.toStringAsFixed(1);
      return;
    }
    final clamped = _round1(parsed.clamp(_draftState.tempSetpoint, 50.0));
    setState(() {
      _draftState = _draftState.copyWith(tempUpper: clamped);
    });
    _tempUpperController.text = _draftState.tempUpper.toStringAsFixed(1);
  }

  void _commitTempLower(String raw) {
    final parsed = double.tryParse(raw.replaceAll(',', '.'));
    if (parsed == null) {
      _tempLowerController.text = _draftState.tempLower.toStringAsFixed(1);
      return;
    }
    final clamped = _round1(parsed.clamp(0.0, _draftState.tempSetpoint));
    setState(() {
      _draftState = _draftState.copyWith(tempLower: clamped);
    });
    _tempLowerController.text = _draftState.tempLower.toStringAsFixed(1);
  }

  void _commitHumiditySetpoint(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      _humiditySetpointController.text = _draftState.humiditySetpoint.toString();
      return;
    }
    final clamped = parsed.clamp(_draftState.humidityLower, _draftState.humidityUpper);
    setState(() {
      _draftState = _draftState.copyWith(humiditySetpoint: clamped);
    });
    _humiditySetpointController.text = _draftState.humiditySetpoint.toString();
  }

  void _commitHumidityUpper(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      _humidityUpperController.text = _draftState.humidityUpper.toString();
      return;
    }
    final clamped = parsed.clamp(_draftState.humiditySetpoint, 100);
    setState(() {
      _draftState = _draftState.copyWith(humidityUpper: clamped);
    });
    _humidityUpperController.text = _draftState.humidityUpper.toString();
  }

  void _commitHumidityLower(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      _humidityLowerController.text = _draftState.humidityLower.toString();
      return;
    }
    final clamped = parsed.clamp(0, _draftState.humiditySetpoint);
    setState(() {
      _draftState = _draftState.copyWith(humidityLower: clamped);
    });
    _humidityLowerController.text = _draftState.humidityLower.toString();
  }

  void _commitLightSetpoint(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      _lightSetpointController.text = _draftState.lightSetpoint.toString();
      return;
    }
    final clamped = parsed.clamp(_draftState.lightLower, _draftState.lightUpper);
    setState(() {
      _draftState = _draftState.copyWith(lightSetpoint: clamped);
    });
    _lightSetpointController.text = _draftState.lightSetpoint.toString();
  }

  void _commitLightUpper(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      _lightUpperController.text = _draftState.lightUpper.toString();
      return;
    }
    final clamped = parsed.clamp(_draftState.lightSetpoint, 20000);
    setState(() {
      _draftState = _draftState.copyWith(lightUpper: clamped);
    });
    _lightUpperController.text = _draftState.lightUpper.toString();
  }

  void _commitLightLower(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      _lightLowerController.text = _draftState.lightLower.toString();
      return;
    }
    final clamped = parsed.clamp(0, _draftState.lightSetpoint);
    setState(() {
      _draftState = _draftState.copyWith(lightLower: clamped);
    });
    _lightLowerController.text = _draftState.lightLower.toString();
  }

  void _commitIntakeFan(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      _intakeController.text = _draftState.intakeFanSpeed.toString();
      return;
    }
    final clamped = parsed.clamp(0, 100);
    setState(() {
      _draftState = _draftState.copyWith(intakeFanSpeed: clamped);
    });
    _intakeController.text = _draftState.intakeFanSpeed.toString();
  }

  void _commitExhaustFan(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      _exhaustController.text = _draftState.exhaustFanSpeed.toString();
      return;
    }
    final clamped = parsed.clamp(0, 100);
    setState(() {
      _draftState = _draftState.copyWith(exhaustFanSpeed: clamped);
    });
    _exhaustController.text = _draftState.exhaustFanSpeed.toString();
  }

  void _commitDelayBlower(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      _delayBlowerController.text = _draftState.blowerDelay.toString();
      return;
    }
    final clamped = parsed.clamp(0, 100);
    setState(() {
      _draftState = _draftState.copyWith(blowerDelay: clamped);
    });
    _delayBlowerController.text = _draftState.blowerDelay.toString();
  }

  void _commitMistOff(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      _mistOffController.text = _draftState.mistOff.toString();
      return;
    }
    final clamped = parsed.clamp(0, 100);
    setState(() {
      _draftState = _draftState.copyWith(mistOff: clamped);
    });
    _mistOffController.text = _draftState.mistOff.toString();
  }

  // --- Handlers: +/- Stepper Buttons ---

  void _decreaseTempSetpoint() {
    final next = _round1(_draftState.tempSetpoint - 0.1);
    if (next >= _draftState.tempLower) {
      setState(() {
        _draftState = _draftState.copyWith(tempSetpoint: next);
        _tempSetpointController.text = _draftState.tempSetpoint.toStringAsFixed(1);
      });
    }
  }

  void _increaseTempSetpoint() {
    final next = _round1(_draftState.tempSetpoint + 0.1);
    if (next <= _draftState.tempUpper) {
      setState(() {
        _draftState = _draftState.copyWith(tempSetpoint: next);
        _tempSetpointController.text = _draftState.tempSetpoint.toStringAsFixed(1);
      });
    }
  }

  void _decreaseTempUpper() {
    final next = _round1(_draftState.tempUpper - 0.1);
    if (next >= _draftState.tempSetpoint) {
      setState(() {
        _draftState = _draftState.copyWith(tempUpper: next);
        _tempUpperController.text = _draftState.tempUpper.toStringAsFixed(1);
      });
    }
  }

  void _increaseTempUpper() {
    final next = _round1(_draftState.tempUpper + 0.1);
    if (next <= 50.0) {
      setState(() {
        _draftState = _draftState.copyWith(tempUpper: next);
        _tempUpperController.text = _draftState.tempUpper.toStringAsFixed(1);
      });
    }
  }

  void _decreaseTempLower() {
    final next = _round1(_draftState.tempLower - 0.1);
    if (next >= 0.0) {
      setState(() {
        _draftState = _draftState.copyWith(tempLower: next);
        _tempLowerController.text = _draftState.tempLower.toStringAsFixed(1);
      });
    }
  }

  void _increaseTempLower() {
    final next = _round1(_draftState.tempLower + 0.1);
    if (next <= _draftState.tempSetpoint) {
      setState(() {
        _draftState = _draftState.copyWith(tempLower: next);
        _tempLowerController.text = _draftState.tempLower.toStringAsFixed(1);
      });
    }
  }

  void _decreaseHumiditySetpoint() {
    if (_draftState.humiditySetpoint - 1 >= _draftState.humidityLower) {
      setState(() {
        _draftState = _draftState.copyWith(
          humiditySetpoint: _draftState.humiditySetpoint - 1,
        );
        _humiditySetpointController.text =
            _draftState.humiditySetpoint.toString();
      });
    }
  }

  void _increaseHumiditySetpoint() {
    if (_draftState.humiditySetpoint + 1 <= _draftState.humidityUpper) {
      setState(() {
        _draftState = _draftState.copyWith(
          humiditySetpoint: _draftState.humiditySetpoint + 1,
        );
        _humiditySetpointController.text =
            _draftState.humiditySetpoint.toString();
      });
    }
  }

  void _decreaseHumidityUpper() {
    if (_draftState.humidityUpper - 1 >= _draftState.humiditySetpoint) {
      setState(() {
        _draftState = _draftState.copyWith(
          humidityUpper: _draftState.humidityUpper - 1,
        );
        _humidityUpperController.text =
            _draftState.humidityUpper.toString();
      });
    }
  }

  void _increaseHumidityUpper() {
    if (_draftState.humidityUpper + 1 <= 100) {
      setState(() {
        _draftState = _draftState.copyWith(
          humidityUpper: _draftState.humidityUpper + 1,
        );
        _humidityUpperController.text =
            _draftState.humidityUpper.toString();
      });
    }
  }

  void _decreaseHumidityLower() {
    if (_draftState.humidityLower - 1 >= 0) {
      setState(() {
        _draftState = _draftState.copyWith(
          humidityLower: _draftState.humidityLower - 1,
        );
        _humidityLowerController.text =
            _draftState.humidityLower.toString();
      });
    }
  }

  void _increaseHumidityLower() {
    if (_draftState.humidityLower + 1 <= _draftState.humiditySetpoint) {
      setState(() {
        _draftState = _draftState.copyWith(
          humidityLower: _draftState.humidityLower + 1,
        );
        _humidityLowerController.text =
            _draftState.humidityLower.toString();
      });
    }
  }

  void _decreaseLightSetpoint() {
    if (_draftState.lightSetpoint - 100 >= _draftState.lightLower) {
      setState(() {
        _draftState = _draftState.copyWith(
          lightSetpoint: _draftState.lightSetpoint - 100,
        );
        _lightSetpointController.text =
            _draftState.lightSetpoint.toString();
      });
    }
  }

  void _increaseLightSetpoint() {
    if (_draftState.lightSetpoint + 100 <= _draftState.lightUpper) {
      setState(() {
        _draftState = _draftState.copyWith(
          lightSetpoint: _draftState.lightSetpoint + 100,
        );
        _lightSetpointController.text =
            _draftState.lightSetpoint.toString();
      });
    }
  }

  void _decreaseLightUpper() {
    if (_draftState.lightUpper - 100 >= _draftState.lightSetpoint) {
      setState(() {
        _draftState = _draftState.copyWith(
          lightUpper: _draftState.lightUpper - 100,
        );
        _lightUpperController.text =
            _draftState.lightUpper.toString();
      });
    }
  }

  void _increaseLightUpper() {
    if (_draftState.lightUpper + 100 <= 20000) {
      setState(() {
        _draftState = _draftState.copyWith(
          lightUpper: _draftState.lightUpper + 100,
        );
        _lightUpperController.text =
            _draftState.lightUpper.toString();
      });
    }
  }

  void _decreaseLightLower() {
    if (_draftState.lightLower - 100 >= 0) {
      setState(() {
        _draftState = _draftState.copyWith(
          lightLower: _draftState.lightLower - 100,
        );
        _lightLowerController.text =
            _draftState.lightLower.toString();
      });
    }
  }

  void _increaseLightLower() {
    if (_draftState.lightLower + 100 <= _draftState.lightSetpoint) {
      setState(() {
        _draftState = _draftState.copyWith(
          lightLower: _draftState.lightLower + 100,
        );
        _lightLowerController.text =
            _draftState.lightLower.toString();
      });
    }
  }

  void _decreaseIntakeFan() {
    if (_draftState.intakeFanSpeed - 5 >= 0) {
      setState(() {
        _draftState = _draftState.copyWith(
          intakeFanSpeed: _draftState.intakeFanSpeed - 5,
        );
        _intakeController.text = _draftState.intakeFanSpeed.toString();
      });
    }
  }

  void _increaseIntakeFan() {
    if (_draftState.intakeFanSpeed + 5 <= 100) {
      setState(() {
        _draftState = _draftState.copyWith(
          intakeFanSpeed: _draftState.intakeFanSpeed + 5,
        );
        _intakeController.text = _draftState.intakeFanSpeed.toString();
      });
    }
  }

  void _decreaseExhaustFan() {
    if (_draftState.exhaustFanSpeed - 5 >= 0) {
      setState(() {
        _draftState = _draftState.copyWith(
          exhaustFanSpeed: _draftState.exhaustFanSpeed - 5,
        );
        _exhaustController.text = _draftState.exhaustFanSpeed.toString();
      });
    }
  }

  void _increaseExhaustFan() {
    if (_draftState.exhaustFanSpeed + 5 <= 100) {
      setState(() {
        _draftState = _draftState.copyWith(
          exhaustFanSpeed: _draftState.exhaustFanSpeed + 5,
        );
        _exhaustController.text = _draftState.exhaustFanSpeed.toString();
      });
    }
  }

  void _decreaseBlowerDelay() {
    if (_draftState.blowerDelay - 5 >= 0) {
      setState(() {
        _draftState = _draftState.copyWith(
          blowerDelay: _draftState.blowerDelay - 5,
        );
        _delayBlowerController.text = _draftState.blowerDelay.toString();
      });
    }
  }

  void _increaseBlowerDelay() {
    if (_draftState.blowerDelay + 5 <= 100) {
      setState(() {
        _draftState = _draftState.copyWith(
          blowerDelay: _draftState.blowerDelay + 5,
        );
        _delayBlowerController.text = _draftState.blowerDelay.toString();
      });
    }
  }

  void _decreaseMistOff() {
    if (_draftState.mistOff - 5 >= 0) {
      setState(() {
        _draftState = _draftState.copyWith(
          mistOff: _draftState.mistOff - 5,
        );
        _mistOffController.text = _draftState.mistOff.toString();
      });
    }
  }

  void _increaseMistOff() {
    if (_draftState.mistOff + 5 <= 100) {
      setState(() {
        _draftState = _draftState.copyWith(
          mistOff: _draftState.mistOff + 5,
        );
        _mistOffController.text = _draftState.mistOff.toString();
      });
    }
  }

  // --- Discard Changes Handler ---
  Future<void> _promptDiscardChanges() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const DiscardConfirmDialog(),
    );

    if (confirmed == true && mounted) {
      _discardChanges();
    }
  }

  void _discardChanges() {
    FocusScope.of(context).unfocus();

    setState(() {
      _draftState = _savedState;
      _tempSetpointController.text =
          _savedState.tempSetpoint.toStringAsFixed(1);
      _tempUpperController.text =
          _savedState.tempUpper.toStringAsFixed(1);
      _tempLowerController.text =
          _savedState.tempLower.toStringAsFixed(1);

      _humiditySetpointController.text =
          _savedState.humiditySetpoint.toString();
      _humidityUpperController.text =
          _savedState.humidityUpper.toString();
      _humidityLowerController.text =
          _savedState.humidityLower.toString();

      _lightSetpointController.text =
          _savedState.lightSetpoint.toString();
      _lightUpperController.text =
          _savedState.lightUpper.toString();
      _lightLowerController.text =
          _savedState.lightLower.toString();

      _intakeController.text =
          _savedState.intakeFanSpeed.toString();
      _exhaustController.text =
          _savedState.exhaustFanSpeed.toString();

      _delayBlowerController.text =
          _savedState.blowerDelay.toString();
      _mistOffController.text =
          _savedState.mistOff.toString();
    });
  }

  // --- Save Changes Handlers ---
  void _saveChangesSilently() {
    _savedState = _draftState;
    SetpointProtection.savedData = _savedState;
    _savedIntakeDefault = _savedState.intakeFanSpeed;
    _savedExhaustDefault = _savedState.exhaustFanSpeed;
    _savedBlowerDelaySeconds = _savedState.blowerDelay;
  }

  void _saveChanges() {
    FocusScope.of(context).unfocus();

    setState(() {
      _saveChangesSilently();
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Setpoint changes applied successfully'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final proceed = await SetpointProtection.confirmNavigation(context);
        if (proceed && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Bagian Atas
              _buildHeader(context),

              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.lightBorder,
              ),

              // 2. Konten Utama Setpoint
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 28.0 : 16.0,
                  vertical: isDesktop ? 22.0 : 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDesktop)
                      _buildDesktopLayout()
                    else
                      _buildMobileLayout(),

                    const SizedBox(height: 18),

                    // Card Automatic Logic (informational)
                    const AutomaticLogicCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            hasUnsavedChanges ? _buildStickyActionBar(isDesktop) : null,
      ),
    );
  }

  /// Header Setpoint yang konsisten dengan Dashboard dan Kontrol Perangkat
  Widget _buildHeader(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 28.0 : 16.0,
        vertical: 18.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Judul, Indikator Unsaved changes, & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Setpoint',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightTextPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (hasUnsavedChanges) ...[
                      const SizedBox(width: 14),
                      Container(
                        key: const Key('unsaved_changes_header_indicator'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFBBF7D0),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 7,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              modifiedParametersCount > 0
                                  ? 'Unsaved changes · $modifiedParametersCount'
                                  : 'Unsaved changes',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Configure target ranges for automatic control',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Waktu & Tanggal
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '14:32',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '26 Apr 2025',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.lightTextSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Sticky Action Bar di bagian bawah layar saat terdapat perubahan belum disimpan
  Widget _buildStickyActionBar(bool isDesktop) {
    return Container(
      key: const Key('setpoint_sticky_action_bar'),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 28.0 : 16.0,
        vertical: 14.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: AppColors.lightBorder, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, -3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Kiri: Info perubahan
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                modifiedParametersCount > 0
                    ? 'Unsaved changes ($modifiedParametersCount)'
                    : 'Unsaved changes',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),

          // Kanan: [Discard changes] [Apply changes]
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                key: const Key('action_bar_discard_btn'),
                onPressed: _promptDiscardChanges,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.lightTextPrimary,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.0),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Discard changes',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                key: const Key('action_bar_apply_btn'),
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Apply changes',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Susunan 3 Kolom Desktop sesuai desain Figma
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // KIRI: Temperature & Cahaya
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildTemperatureCard(),
              const SizedBox(height: 18),
              _buildCahayaCard(),
            ],
          ),
        ),

        const SizedBox(width: 18),

        // TENGAH: Kelembapan, Ventilasi (Kipas), Parameter Lainnya
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildKelembapanCard(),
              const SizedBox(height: 18),
              _buildVentilasiCard(),
              const SizedBox(height: 18),
              _buildParameterLainnyaCard(),
            ],
          ),
        ),

        const SizedBox(width: 18),

        // KANAN: Ventilation defaults
        Expanded(
          flex: 1,
          child: _buildVentilationDefaultsCard(),
        ),
      ],
    );
  }

  /// Susunan Kolom Responsif untuk Mobile / Tablet
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildTemperatureCard(),
        const SizedBox(height: 14),
        _buildKelembapanCard(),
        const SizedBox(height: 14),
        _buildCahayaCard(),
        const SizedBox(height: 14),
        _buildVentilasiCard(),
        const SizedBox(height: 14),
        _buildParameterLainnyaCard(),
        const SizedBox(height: 14),
        _buildVentilationDefaultsCard(),
      ],
    );
  }

  // ==========================================
  // CARDS BUILDERS
  // ==========================================

  /// 1. Card Temperature
  Widget _buildTemperatureCard() {
    return SetpointCard(
      isModified: isTempModified,
      iconWidget: const Icon(
        Icons.thermostat_outlined,
        size: 24,
        color: AppColors.lightTextPrimary,
      ),
      title: 'Temperature',
      children: [
        SetpointStepperRow(
          label: 'Setpoint',
          controller: _tempSetpointController,
          focusNode: _tempSetpointFocus,
          unit: '°C',
          isDecimal: true,
          onSubmitted: _commitTempSetpoint,
          onDecrement: _round1(_draftState.tempSetpoint - 0.1) >=
                  _draftState.tempLower
              ? _decreaseTempSetpoint
              : null,
          onIncrement: _round1(_draftState.tempSetpoint + 0.1) <=
                  _draftState.tempUpper
              ? _increaseTempSetpoint
              : null,
          decKey: const Key('temp_setpoint_dec'),
          incKey: const Key('temp_setpoint_inc'),
          valKey: const Key('temp_setpoint_val'),
          inputKey: const Key('temp_setpoint_input'),
        ),
        SetpointStepperRow(
          label: 'Batas Atas',
          controller: _tempUpperController,
          focusNode: _tempUpperFocus,
          unit: '°C',
          isDecimal: true,
          onSubmitted: _commitTempUpper,
          onDecrement: _round1(_draftState.tempUpper - 0.1) >=
                  _draftState.tempSetpoint
              ? _decreaseTempUpper
              : null,
          onIncrement:
              _draftState.tempUpper + 0.1 <= 50.0 ? _increaseTempUpper : null,
          decKey: const Key('temp_upper_dec'),
          incKey: const Key('temp_upper_inc'),
          valKey: const Key('temp_upper_val'),
          inputKey: const Key('temp_upper_input'),
        ),
        SetpointStepperRow(
          label: 'Batas Bawah',
          controller: _tempLowerController,
          focusNode: _tempLowerFocus,
          unit: '°C',
          isDecimal: true,
          onSubmitted: _commitTempLower,
          onDecrement: _draftState.tempLower - 0.1 >= 0.0
              ? _decreaseTempLower
              : null,
          onIncrement: _round1(_draftState.tempLower + 0.1) <=
                  _draftState.tempSetpoint
              ? _increaseTempLower
              : null,
          decKey: const Key('temp_lower_dec'),
          incKey: const Key('temp_lower_inc'),
          valKey: const Key('temp_lower_val'),
          inputKey: const Key('temp_lower_input'),
        ),
      ],
    );
  }

  /// 2. Card Kelembapan
  Widget _buildKelembapanCard() {
    return SetpointCard(
      isModified: isHumidityModified,
      iconWidget: const Icon(
        Icons.water_drop,
        size: 24,
        color: Color(0xFF0284C7), // Blue
      ),
      title: 'Kelembapan',
      children: [
        SetpointStepperRow(
          label: 'Setpoint',
          controller: _humiditySetpointController,
          focusNode: _humiditySetpointFocus,
          unit: '%RH',
          isDecimal: false,
          onSubmitted: _commitHumiditySetpoint,
          onDecrement:
              _draftState.humiditySetpoint - 1 >= _draftState.humidityLower
                  ? _decreaseHumiditySetpoint
                  : null,
          onIncrement:
              _draftState.humiditySetpoint + 1 <= _draftState.humidityUpper
                  ? _increaseHumiditySetpoint
                  : null,
          decKey: const Key('humidity_setpoint_dec'),
          incKey: const Key('humidity_setpoint_inc'),
          valKey: const Key('humidity_setpoint_val'),
          inputKey: const Key('humidity_setpoint_input'),
        ),
        SetpointStepperRow(
          label: 'Batas Atas',
          controller: _humidityUpperController,
          focusNode: _humidityUpperFocus,
          unit: '%RH',
          isDecimal: false,
          onSubmitted: _commitHumidityUpper,
          onDecrement:
              _draftState.humidityUpper - 1 >= _draftState.humiditySetpoint
                  ? _decreaseHumidityUpper
                  : null,
          onIncrement: _draftState.humidityUpper + 1 <= 100
              ? _increaseHumidityUpper
              : null,
          decKey: const Key('humidity_upper_dec'),
          incKey: const Key('humidity_upper_inc'),
          valKey: const Key('humidity_upper_val'),
          inputKey: const Key('humidity_upper_input'),
        ),
        SetpointStepperRow(
          label: 'Batas Bawah',
          controller: _humidityLowerController,
          focusNode: _humidityLowerFocus,
          unit: '%RH',
          isDecimal: false,
          onSubmitted: _commitHumidityLower,
          onDecrement: _draftState.humidityLower - 1 >= 0
              ? _decreaseHumidityLower
              : null,
          onIncrement:
              _draftState.humidityLower + 1 <= _draftState.humiditySetpoint
                  ? _increaseHumidityLower
                  : null,
          decKey: const Key('humidity_lower_dec'),
          incKey: const Key('humidity_lower_inc'),
          valKey: const Key('humidity_lower_val'),
          inputKey: const Key('humidity_lower_input'),
        ),
      ],
    );
  }

  /// 3. Card Cahaya
  Widget _buildCahayaCard() {
    return SetpointCard(
      isModified: isLightModified,
      iconWidget: const Icon(
        Icons.speed_outlined,
        size: 24,
        color: AppColors.lightTextPrimary,
      ),
      title: 'Cahaya',
      children: [
        SetpointStepperRow(
          label: 'Setpoint',
          controller: _lightSetpointController,
          focusNode: _lightSetpointFocus,
          unit: 'lux',
          isDecimal: false,
          onSubmitted: _commitLightSetpoint,
          onDecrement:
              _draftState.lightSetpoint - 100 >= _draftState.lightLower
                  ? _decreaseLightSetpoint
                  : null,
          onIncrement:
              _draftState.lightSetpoint + 100 <= _draftState.lightUpper
                  ? _increaseLightSetpoint
                  : null,
          decKey: const Key('light_setpoint_dec'),
          incKey: const Key('light_setpoint_inc'),
          valKey: const Key('light_setpoint_val'),
          inputKey: const Key('light_setpoint_input'),
        ),
        SetpointStepperRow(
          label: 'Batas Atas',
          controller: _lightUpperController,
          focusNode: _lightUpperFocus,
          unit: 'lux',
          isDecimal: false,
          onSubmitted: _commitLightUpper,
          onDecrement:
              _draftState.lightUpper - 100 >= _draftState.lightSetpoint
                  ? _decreaseLightUpper
                  : null,
          onIncrement: _draftState.lightUpper + 100 <= 20000
              ? _increaseLightUpper
              : null,
          decKey: const Key('light_upper_dec'),
          incKey: const Key('light_upper_inc'),
          valKey: const Key('light_upper_val'),
          inputKey: const Key('light_upper_input'),
        ),
        SetpointStepperRow(
          label: 'Batas Bawah',
          controller: _lightLowerController,
          focusNode: _lightLowerFocus,
          unit: 'lux',
          isDecimal: false,
          onSubmitted: _commitLightLower,
          onDecrement: _draftState.lightLower - 100 >= 0
              ? _decreaseLightLower
              : null,
          onIncrement:
              _draftState.lightLower + 100 <= _draftState.lightSetpoint
                  ? _increaseLightLower
                  : null,
          decKey: const Key('light_lower_dec'),
          incKey: const Key('light_lower_inc'),
          valKey: const Key('light_lower_val'),
          inputKey: const Key('light_lower_input'),
        ),
      ],
    );
  }

  /// 4. Card Ventilasi (Kipas)
  Widget _buildVentilasiCard() {
    return SetpointCard(
      isModified: isVentilasiModified,
      iconWidget: const SizedBox(
        width: 24,
        height: 24,
        child: CustomPaint(
          painter: DeviceFanPainter(color: AppColors.lightTextPrimary),
        ),
      ),
      title: 'Ventilasi (Kipas)',
      children: [
        SetpointStepperRow(
          label: 'Kecepatan\nIntake',
          controller: _intakeController,
          focusNode: _intakeFocus,
          unit: '%',
          isDecimal: false,
          onSubmitted: _commitIntakeFan,
          onDecrement: _draftState.intakeFanSpeed - 5 >= 0
              ? _decreaseIntakeFan
              : null,
          onIncrement: _draftState.intakeFanSpeed + 5 <= 100
              ? _increaseIntakeFan
              : null,
          decKey: const Key('intake_dec'),
          incKey: const Key('intake_inc'),
          valKey: const Key('intake_val'),
          inputKey: const Key('intake_input'),
        ),
        SetpointStepperRow(
          label: 'Kecepatan\nExhaust',
          controller: _exhaustController,
          focusNode: _exhaustFocus,
          unit: '%',
          isDecimal: false,
          onSubmitted: _commitExhaustFan,
          onDecrement: _draftState.exhaustFanSpeed - 5 >= 0
              ? _decreaseExhaustFan
              : null,
          onIncrement: _draftState.exhaustFanSpeed + 5 <= 100
              ? _increaseExhaustFan
              : null,
          decKey: const Key('exhaust_dec'),
          incKey: const Key('exhaust_inc'),
          valKey: const Key('exhaust_val'),
          inputKey: const Key('exhaust_input'),
        ),
      ],
    );
  }

  /// 5. Card Parameter Lainnya
  Widget _buildParameterLainnyaCard() {
    return SetpointCard(
      isModified: isLainnyaModified,
      iconWidget: const Icon(
        Icons.more_horiz,
        size: 24,
        color: AppColors.lightTextPrimary,
      ),
      title: 'Parameter Lainnya',
      children: [
        SetpointStepperRow(
          label: 'Delay Blower',
          controller: _delayBlowerController,
          focusNode: _delayBlowerFocus,
          unit: '%',
          isDecimal: false,
          onSubmitted: _commitDelayBlower,
          onDecrement:
              _draftState.blowerDelay - 5 >= 0 ? _decreaseBlowerDelay : null,
          onIncrement:
              _draftState.blowerDelay + 5 <= 100 ? _increaseBlowerDelay : null,
          decKey: const Key('delay_blower_dec'),
          incKey: const Key('delay_blower_inc'),
          valKey: const Key('delay_blower_val'),
          inputKey: const Key('delay_blower_input'),
        ),
        SetpointStepperRow(
          label: 'setelah\nMist OFF',
          controller: _mistOffController,
          focusNode: _mistOffFocus,
          unit: '%',
          isDecimal: false,
          onSubmitted: _commitMistOff,
          onDecrement: _draftState.mistOff - 5 >= 0 ? _decreaseMistOff : null,
          onIncrement: _draftState.mistOff + 5 <= 100 ? _increaseMistOff : null,
          decKey: const Key('mist_off_dec'),
          incKey: const Key('mist_off_inc'),
          valKey: const Key('mist_off_val'),
          inputKey: const Key('mist_off_input'),
        ),
      ],
    );
  }

  /// 6. Card Ventilation Defaults
  Widget _buildVentilationDefaultsCard() {
    return VentilationDefaultsCard(
      intakeFanSpeed: _savedIntakeDefault,
      exhaustFanSpeed: _savedExhaustDefault,
      blowerDelaySeconds: _savedBlowerDelaySeconds,
    );
  }
}
