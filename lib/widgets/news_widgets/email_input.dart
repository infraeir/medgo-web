import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'short_text_input.dart';

class EmailInputMedgo extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final List<String>? autofillHints;
  final bool isRequired;

  const EmailInputMedgo({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.autofillHints,
    this.isRequired = false,
  }) : super(key: key);

  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInputMedgo> {
  bool _isValidEmail = true;

  // Função para validar o formato do e-mail
  bool _validateEmail(String email) {
    return RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    ).hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return ShortTextInputMedgo(
      controller: widget.controller,
      labelText: widget.labelText,
      autofillHints: widget.autofillHints ?? const [AutofillHints.email],
      hintText: widget.hintText ?? 'seuemail@exemplo.com',
      enabled: widget.enabled,
      errorText:
          widget.errorText ?? (!_isValidEmail ? 'E-mail inválido' : null),
      isRequired: widget.isRequired,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            _isValidEmail = _validateEmail(value);
          });
        }
        widget.onChanged?.call(value);
      },
      // Ícone prefixo personalizado para e-mail
      prefixIcon: PhosphorIcons.at(
        PhosphorIconsStyle.duotone,
      ),
    );
  }
}
