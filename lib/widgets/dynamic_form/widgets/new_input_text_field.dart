import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:medgo/themes/app_theme.dart';

class NewInputTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String hintText;
  final String labelText;
  final String? errorText;
  final double? height;
  final double? width;
  final Icon? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String value) onChanged;
  final bool isError;
  final bool readOnly;
  final bool disabled;
  final int? maxLines;
  final String? errorMessage;
  final FocusNode? focusNode;

  const NewInputTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.onChanged,
    this.height,
    this.width,
    this.errorText,
    this.prefixIcon,
    this.isError = false,
    this.readOnly = false,
    this.disabled = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines,
    this.errorMessage,
    this.focusNode,
  }) : super(key: key);

  @override
  _NewInputTextFieldState createState() => _NewInputTextFieldState();
}

class _NewInputTextFieldState extends State<NewInputTextField> {
  bool _hasFocus = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color borderColor = widget.isError
        ? AppTheme.error
        : widget.disabled
            ? Colors.grey
            : const Color(0xFF004155);
    Color textColor = widget.isError
        ? AppTheme.error
        : widget.disabled
            ? Colors.grey
            : Colors.black;
    Color backgroundColor =
        widget.disabled ? Colors.grey.shade300 : Colors.white;

    return SizedBox(
      height: (widget.isError && widget.errorMessage != null) ? (widget.height! + 20.0) : widget.height,
      width: widget.width ?? 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Focus(
              onFocusChange: (hasFocus) => setState(() => _hasFocus = hasFocus),
              child: TextFormField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                inputFormatters: widget.inputFormatters ?? [],
                onChanged: widget.disabled ? (_) {} : widget.onChanged,
                maxLines: widget.maxLines,
                keyboardType: widget.maxLines == null
                    ? TextInputType.multiline
                    : widget.keyboardType,
                textInputAction: widget.maxLines == null
                    ? TextInputAction.newline
                    : TextInputAction.done,
                enabled: !widget.disabled,
                cursorColor: Colors.grey,
                textAlign: (_hasFocus || _isHovered)
                    ? TextAlign.start
                    : TextAlign.center,
                decoration: InputDecoration(
                  fillColor: (_hasFocus || _isHovered)
                      ? _hasFocus
                          ? Colors.white
                          : const Color(0xFF78A6C8)
                      : backgroundColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE67F75),
                      width: 2.0,
                    ),
                  ),
                  hoverColor: const Color(0xFF78A6C8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppTheme.theme.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: widget.hintText,
                  labelText: widget.labelText,
                  labelStyle: TextStyle(
                    color: textColor,
                    fontSize: 18,
                  ),
                  hintStyle: TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 18,
                  ),
                  prefixIcon: widget.prefixIcon,
                  prefixIconColor: textColor,
                  suffixIcon: widget.isError
                      ? Icon(
                          Icons.error_rounded,
                          color: AppTheme.error,
                        )
                      : null,
                  errorStyle: TextStyle(color: AppTheme.error),
                  errorText: widget.errorText,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  alignLabelWithHint: true,
                ),
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          if (widget.isError && widget.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.errorMessage!,
                style: TextStyle(
                  color: AppTheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
