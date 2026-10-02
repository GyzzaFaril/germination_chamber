import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

/// Komponen baris parameter dengan kontrol steper dan value box editable:
/// [-] [ TextField + Unit ] [+]
class SetpointStepperRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String unit;
  final bool isDecimal;
  final ValueChanged<String> onSubmitted;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final Key? decKey;
  final Key? incKey;
  final Key? valKey;
  final Key? inputKey;

  const SetpointStepperRow({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.unit,
    this.isDecimal = false,
    required this.onSubmitted,
    required this.onDecrement,
    required this.onIncrement,
    this.decKey,
    this.incKey,
    this.valKey,
    this.inputKey,
  });

  double _getFieldWidth(String unit) {
    switch (unit) {
      case 'lux':
        return 40.0;
      case '°C':
        return 34.0;
      case '%RH':
        return 26.0;
      case '%':
        return 26.0;
      default:
        return 28.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label Parameter (Mendukung multi-baris seperti 'Kecepatan\nIntake' atau 'setelah\nMist OFF')
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextPrimary,
              height: 1.25,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Kontrol [-] [ TextField + unit ] [+]
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Decrement [-]
            _buildStepperButton(
              key: decKey,
              icon: Icons.remove,
              onPressed: onDecrement,
            ),

            const SizedBox(width: 6),

            // Value Box Editable: [ Angka   Unit ]
            GestureDetector(
              onTap: () {
                focusNode.requestFocus();
                controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: controller.text.length,
                );
              },
              child: AnimatedBuilder(
                animation: focusNode,
                builder: (context, child) {
                  final isFocused = focusNode.hasFocus;
                  return Container(
                    key: valKey,
                    width: 96,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9), // Slate 100 - Always light gray
                      borderRadius: BorderRadius.circular(6),
                      border: isFocused
                          ? Border.all(color: AppColors.primary, width: 1.0)
                          : Border.all(color: Colors.transparent, width: 1.0),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Input Field Numerik dengan theme eksplisit bebas overlay gelap
                        SizedBox(
                          width: _getFieldWidth(unit),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: const TextSelectionThemeData(
                                selectionColor: Color(0x3800853E), // Translucent brand green
                                cursorColor: AppColors.primary,
                                selectionHandleColor: AppColors.primary,
                              ),
                            ),
                            child: TextField(
                              key: inputKey,
                              controller: controller,
                              focusNode: focusNode,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: isDecimal,
                              ),
                              inputFormatters: isDecimal
                                  ? [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*[\.,]?\d*'),
                                      ),
                                    ]
                                  : [FilteringTextInputFormatter.digitsOnly],
                              textAlign: TextAlign.center,
                              cursorColor: AppColors.primary,
                              cursorWidth: 1.5,
                              cursorHeight: 14,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.lightTextPrimary, // Dark Navy / Slate 800
                                letterSpacing: 0.1,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                contentPadding: EdgeInsets.symmetric(vertical: 6),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                              onSubmitted: (val) {
                                onSubmitted(val);
                                focusNode.unfocus();
                              },
                              onTap: () {
                                controller.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: controller.text.length,
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 3),

                        // Unit Suffix Tetap
                        Text(
                          unit,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightTextPrimary,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 6),

            // Tombol Increment [+]
            _buildStepperButton(
              key: incKey,
              icon: Icons.add,
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepperButton({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: key,
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9), // Slate 100
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 15,
            color: isEnabled ? const Color(0xFF64748B) : const Color(0xFFCBD5E1),
          ),
        ),
      ),
    );
  }
}
