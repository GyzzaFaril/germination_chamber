import 'package:flutter/material.dart';

/// Screen placeholder untuk modul Setpoint
class SetpointScreen extends StatelessWidget {
  const SetpointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setpoint')),
      body: const Center(
        child: Text('Modul Setpoint siap menerima implementasi UI Figma.'),
      ),
    );
  }
}
