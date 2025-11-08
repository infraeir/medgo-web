import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'short_text_input.dart';

class CpfInputMedgo extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool isRequired;

  const CpfInputMedgo({
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
  _CpfInputState createState() => _CpfInputState();
}

class _CpfInputState extends State<CpfInputMedgo> {
  bool _isValidCpf = true;

  // Função para validar CPF
  bool _validateCpf(String cpf) {
    // Remove formatação
    cpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

    if (cpf.isEmpty) return true; // Vazio é válido durante digitação
    if (cpf.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    // Validação dos dígitos verificadores
    List<int> numbers = cpf.split('').map((e) => int.parse(e)).toList();

    // Calcula primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += numbers[i] * (10 - i);
    }
    int firstDigit = 11 - (sum % 11);
    if (firstDigit >= 10) firstDigit = 0;

    if (numbers[9] != firstDigit) return false;

    // Calcula segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += numbers[i] * (11 - i);
    }
    int secondDigit = 11 - (sum % 11);
    if (secondDigit >= 10) secondDigit = 0;

    return numbers[10] == secondDigit;
  }

  @override
  Widget build(BuildContext context) {
    return ShortTextInputMedgo(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText ?? '000.000.000-00',
      enabled: widget.enabled,
      errorText: widget.errorText ?? (!_isValidCpf ? 'CPF inválido' : null),
      isRequired: widget.isRequired,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
        CpfInputFormatter(), // Formata 000.000.000-00
      ],
      onChanged: (value) {
        // Remove formatação para validação
        final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
        if (cleanValue.length == 11) {
          setState(() {
            _isValidCpf = _validateCpf(cleanValue);
          });
        } else {
          setState(() {
            _isValidCpf = true; // Não mostra erro enquanto digita
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

// Formatter para CPF (000.000.000-00)
class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 11; i++) {
      if (i == 3 || i == 6) {
        buffer.write('.');
      } else if (i == 9) {
        buffer.write('-');
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
