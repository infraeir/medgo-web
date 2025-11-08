import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';

import '../../themes/app_theme.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String hintText;
  final String labelText;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Icon? prefixIcon;
  final Icon? suffix;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String value) onChanged;
  final VoidCallback? suffixPressed;
  final bool isError;
  const InputTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.onChanged,
    this.suffixPressed,
    this.height,
    this.width,
    this.borderRadius,
    this.prefixIcon,
    this.suffix,
    this.isError = false,
    this.keyboardType,
    this.inputFormatters,
    this.floatingLabelBehavior,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = isError ? AppTheme.error : AppTheme.theme.primaryColor;
    Color textColor = isError ? AppTheme.error : Colors.black;

    return SizedBox(
      height: height ?? 45,
      width: width ?? 350,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        inputFormatters: inputFormatters ?? [],
        onChanged: onChanged,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          floatingLabelBehavior: floatingLabelBehavior,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          hintText: hintText,
          labelText: labelText,
          labelStyle: TextStyle(color: textColor, fontSize: 16),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: prefixIcon,
          prefixIconColor: textColor,
          iconColor: textColor,
          suffixIcon: isError
              ? const Icon(
                  Icons.error_rounded,
                  color: AppTheme.error,
                )
              : suffix != null
                  ? CustomIconButtonMedGo(
                      onPressed: suffixPressed ?? () {},
                      icon: suffix!,
                    )
                  : null,
          errorStyle: TextStyle(color: AppTheme.error), // Estilo do erro
        ),
      ),
    );
  }
}
