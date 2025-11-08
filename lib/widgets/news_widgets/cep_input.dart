import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medgo/widgets/news_widgets/short_text_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CepInputMedgo extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final ValueChanged<String>? onChanged;
  final bool isRequired;

  const CepInputMedgo({
    super.key,
    this.controller,
    required this.labelText,
    this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShortTextInputMedgo(
      controller: controller,
      labelText: labelText,
      hintText: '00000-000',
      onChanged: onChanged,
      isRequired: isRequired,
      prefixIcon: PhosphorIcons.mapPin(PhosphorIconsStyle.duotone),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CepInputFormatter(),
        LengthLimitingTextInputFormatter(9), // 00000-000
      ],
    );
  }
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    // Remove tudo que não for dígito
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Limita a 8 dígitos
    final limitedDigits =
        digitsOnly.substring(0, digitsOnly.length.clamp(0, 8));

    // Formata: 00000-000
    String formatted = '';

    for (int i = 0; i < limitedDigits.length; i++) {
      if (i == 5) {
        formatted += '-';
      }
      formatted += limitedDigits[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
