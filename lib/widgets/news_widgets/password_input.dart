import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'short_text_input.dart';

class PasswordInputMedgo extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final double iconSize;
  final List<String>? autofillHints;
  final bool isRequired;

  const PasswordInputMedgo({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.iconSize = 20,
    this.autofillHints,
    this.isRequired = false,
  }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInputMedgo> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return ShortTextInputMedgo(
      controller: widget.controller,
      hintText: widget.hintText ?? 'Digite sua senha',
      labelText: widget.labelText,
      obscureText: _obscureText,
      enabled: widget.enabled,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      autofillHints: widget.autofillHints ?? [AutofillHints.password],
      isRequired: widget.isRequired,
      prefixIcon: PhosphorIcons.key(
        PhosphorIconsStyle.duotone,
      ),
      suffixIcon: _obscureText
          ? IconButton(
              onPressed: () {
                _obscureText = false;
                setState(() {});
              },
              icon: Icon(
                PhosphorIcons.eyeSlash(),
                key: const ValueKey('eye_slash'),
                color: AppTheme.primary,
                size: widget.iconSize,
                shadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            )
          : IconButton(
              onPressed: () {
                _obscureText = true;
                setState(() {});
              },
              icon: Icon(
                PhosphorIcons.eye(),
                key: const ValueKey('eye'),
                color: AppTheme.primary,
                size: widget.iconSize,
                shadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
    );
  }
}
