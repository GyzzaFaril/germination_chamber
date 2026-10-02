import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

/// Kontrol manual untuk Fan: Input Angka 0-100% dan Slider yang tersinkronisasi dua arah
class FanSliderControl extends StatefulWidget {
  final String deviceTitle;
  final int value;
  final ValueChanged<int> onChanged;

  const FanSliderControl({
    super.key,
    required this.deviceTitle,
    required this.value,
    required this.onChanged,
  });

  @override
  State<FanSliderControl> createState() => _FanSliderControlState();
}

class _FanSliderControlState extends State<FanSliderControl> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(covariant FanSliderControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final currentTextVal = int.tryParse(_controller.text);
      if (currentTextVal != widget.value) {
        _controller.text = widget.value.toString();
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChange(String text) {
    if (text.isEmpty) {
      widget.onChanged(0);
      return;
    }
    final parsed = int.tryParse(text);
    if (parsed != null) {
      final clamped = parsed.clamp(0, 100);
      widget.onChanged(clamped);
      if (clamped != parsed) {
        _controller.text = clamped.toString();
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Input Numerik Compact dengan Background Putih & Suffix %
        SizedBox(
          width: 64,
          height: 36,
          child: TextField(
            key: Key('input_${widget.deviceTitle}'),
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            cursorColor: AppColors.primary,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 8,
              ),
              suffixText: '%',
              suffixStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: AppColors.lightBorder,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: AppColors.lightBorder,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
            onChanged: _handleTextChange,
          ),
        ),
        const SizedBox(width: 10),

        // Slider Horizontal
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.0,
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: AppColors.primary,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 6.0,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 12.0,
              ),
            ),
            child: Slider(
              key: Key('slider_${widget.deviceTitle}'),
              value: widget.value.toDouble().clamp(0.0, 100.0),
              min: 0.0,
              max: 100.0,
              onChanged: (val) {
                final intVal = val.round();
                _controller.text = intVal.toString();
                widget.onChanged(intVal);
              },
            ),
          ),
        ),
      ],
    );
  }
}
