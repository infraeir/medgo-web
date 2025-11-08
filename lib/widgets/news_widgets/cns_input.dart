import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'short_text_input.dart';

class CnsInputMedgo extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool isRequired;

  const CnsInputMedgo({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.isRequired = false,
  }) : super(key: key);

  @override
  _CnsInputState createState() => _CnsInputState();
}

class _CnsInputState extends State<CnsInputMedgo> {
  bool _isValidCns = true;

  // Função para validar CNS (Cartão Nacional de Saúde)
  bool _validateCns(String cns) {
    // Remove formatação
    cns = cns.replaceAll(RegExp(r'[^\d]'), '');

    if (cns.isEmpty) return true; // Vazio é válido durante digitação
    if (cns.length != 15) return false;

    // CNS deve começar com 1, 2, 7, 8 ou 9
    final firstDigit = int.parse(cns[0]);
    if (![1, 2, 7, 8, 9].contains(firstDigit)) return false;

    // Validação do dígito verificador para CNS que começa com 1 ou 2
    if (firstDigit == 1 || firstDigit == 2) {
      int sum = 0;
      for (int i = 0; i < 15; i++) {
        sum += int.parse(cns[i]) * (15 - i);
      }
      return sum % 11 == 0;
    }

    // Para CNS que começa com 7, 8 ou 9, a validação é mais simples
    // Verifica se não são todos dígitos iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cns)) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ShortTextInputMedgo(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText ?? '000 0000 0000 0000',
      enabled: widget.enabled,
      errorText: widget.errorText ?? (!_isValidCns ? 'CNS inválido' : null),
      isRequired: widget.isRequired,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(15),
        CnsInputFormatter(), // Formata 000 0000 0000 0000
      ],
      onChanged: (value) {
        // Remove formatação para validação
        final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
        if (cleanValue.length == 15) {
          setState(() {
            _isValidCns = _validateCns(cleanValue);
          });
        } else {
          setState(() {
            _isValidCns = true; // Não mostra erro enquanto digita
          });
        }
        widget.onChanged?.call(value);
      },
      prefixIcon: PhosphorIcons.identificationCard(
        PhosphorIconsStyle.duotone,
      ),
    );
  }
}

// Formatter para CNS (000 0000 0000 0000)
class CnsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 15; i++) {
      if (i == 3 || i == 7 || i == 11) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
