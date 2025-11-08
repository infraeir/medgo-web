import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'short_text_input.dart';

class UfInputMedgo extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool isRequired;

  const UfInputMedgo({
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
  _UfInputState createState() => _UfInputState();
}

class _UfInputState extends State<UfInputMedgo> {
  bool _isValidUf = true;

  // Lista de UFs válidas no Brasil
  static const List<String> _validUfs = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];

  // Função para validar a UF
  bool _validateUf(String uf) {
    if (uf.isEmpty)
      return true; // Vazio é válido (não obrigatório validar durante digitação)
    return _validUfs.contains(uf.toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    return ShortTextInputMedgo(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText ?? 'SP',
      enabled: widget.enabled,
      errorText: widget.errorText ?? (!_isValidUf ? 'UF inválida' : null),
      isRequired: widget.isRequired,
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(2), // Máximo 2 caracteres
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')), // Apenas letras
        UpperCaseTextFormatter(), // Converte para maiúsculas
      ],
      onChanged: (value) {
        if (value.length == 2) {
          setState(() {
            _isValidUf = _validateUf(value);
          });
        } else {
          setState(() {
            _isValidUf = true; // Não mostra erro enquanto digita
          });
        }
        widget.onChanged?.call(value);
      },
    );
  }
}

// Formatter para converter texto em maiúsculas
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
