import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'short_text_input.dart';

class PhoneInputMedgo extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool isRequired;

  const PhoneInputMedgo({
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
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInputMedgo> {
  bool _isValidPhone = true;

  // Função para validar telefone celular brasileiro
  bool _validatePhone(String phone) {
    // Remove formatação
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (phone.isEmpty) return true; // Vazio é válido durante digitação

    // Celular brasileiro deve ter 11 dígitos (DDD + 9 + 8 dígitos)
    // Formato: (99) 99999-9999
    if (phone.length != 11) return false;

    // Valida se começa com DDD válido (11-99)
    final ddd = int.tryParse(phone.substring(0, 2));
    if (ddd == null || ddd < 11 || ddd > 99) return false;

    // Valida se o terceiro dígito é 9 (celular)
    if (phone[2] != '9') return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ShortTextInputMedgo(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText ?? '(00) 00000-0000',
      enabled: widget.enabled,
      errorText:
          widget.errorText ?? (!_isValidPhone ? 'Celular inválido' : null),
      isRequired: widget.isRequired,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
        PhoneInputFormatter(), // Formata (00) 00000-0000
      ],
      onChanged: (value) {
        // Remove formatação para validação
        final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
        if (cleanValue.length == 11) {
          setState(() {
            _isValidPhone = _validatePhone(cleanValue);
          });
        } else {
          setState(() {
            _isValidPhone = true; // Não mostra erro enquanto digita
          });
        }
        widget.onChanged?.call(value);
      },
      prefixIcon: PhosphorIcons.phone(
        PhosphorIconsStyle.duotone,
      ),
    );
  }
}

// Formatter para telefone celular (00) 00000-0000
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 11; i++) {
      if (i == 0) {
        buffer.write('(');
      }
      if (i == 2) {
        buffer.write(') ');
      }
      if (i == 7) {
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
