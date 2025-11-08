import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'short_text_input.dart';

class RegistroMedicoInputMedgo extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool isRequired;

  const RegistroMedicoInputMedgo({
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
  _RegistroMedicoInputState createState() => _RegistroMedicoInputState();
}

class _RegistroMedicoInputState extends State<RegistroMedicoInputMedgo> {
  bool _isValid = true;

  // Função para validar o número de registro
  // CRM geralmente tem entre 4 e 8 dígitos
  bool _validateRegistro(String registro) {
    if (registro.isEmpty) return true;
    // Valida se tem apenas números e entre 4 e 8 dígitos
    final numeroRegex = RegExp(r'^\d{4,8}$');
    return numeroRegex.hasMatch(registro);
  }

  @override
  Widget build(BuildContext context) {
    return ShortTextInputMedgo(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText ?? '123456',
      enabled: widget.enabled,
      errorText: widget.errorText ??
          (!_isValid ? 'Registro deve ter entre 4 e 8 dígitos' : null),
      isRequired: widget.isRequired,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Apenas números
        LengthLimitingTextInputFormatter(8), // Máximo 8 dígitos
      ],
      prefixIcon: PhosphorIcons.identificationCard(
        PhosphorIconsStyle.duotone,
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            _isValid = _validateRegistro(value);
          });
        } else {
          setState(() {
            _isValid = true;
          });
        }
        widget.onChanged?.call(value);
      },
    );
  }
}
