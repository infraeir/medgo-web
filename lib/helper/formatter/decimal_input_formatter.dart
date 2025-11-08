import 'package:flutter/services.dart';

class DecimalCommaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Substitui pontos por vírgulas
    String newText = newValue.text.replaceAll('.', ',');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}