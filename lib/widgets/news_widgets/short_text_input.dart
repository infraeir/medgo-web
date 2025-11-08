import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ShortTextInputMedgo extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final bool enabled;
  final String? errorText;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  // Novas propriedades
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final List<String>? autofillHints;
  final bool isRequired; // Nova propriedade para campo obrigatório

  const ShortTextInputMedgo({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.enabled = true,
    this.errorText,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.autofillHints,
    this.isRequired = false, // Padrão false
  }) : super(key: key);

  @override
  _ShortTextInputState createState() => _ShortTextInputState();
}

class _ShortTextInputState extends State<ShortTextInputMedgo> {
  late FocusNode _focusNode;
  bool _isHovering = false;
  bool _isPressed = false; // Novo estado

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller?.addListener(_onTextChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller?.removeListener(_onTextChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChange() {
    setState(() {});
  }

  bool get _hasContent => widget.controller?.text.isNotEmpty ?? false;

  Color _getBorderColor() {
    if (!widget.enabled) return AppTheme.secondaryText;
    if (widget.errorText != null) return AppTheme.error;
    if (_isPressed) return AppTheme.salmon;
    if (_focusNode.hasFocus) return AppTheme.salmon;
    if (_isHovering) return AppTheme.salmon;
    if (_hasContent) return AppTheme.blueLight;
    return AppTheme.primary;
  }

  TextAlign _getTextAligment() {
    if (!widget.enabled ||
        widget.errorText != null ||
        _isPressed ||
        _focusNode.hasFocus ||
        _isHovering ||
        _hasContent) return TextAlign.start;
    return TextAlign.center;
  }

  Color _getBackgroundColor() {
    if (!widget.enabled) return AppTheme.alternate;
    if (_isPressed) return AppTheme.blueDark;
    if (_focusNode.hasFocus) return Colors.white;
    if (_isHovering) return AppTheme.blueLight;
    if (_hasContent) return AppTheme.primary;
    return AppTheme.primaryBackground;
  }

  Color _getTextColor() {
    if (!widget.enabled) return AppTheme.secondaryText;
    if (_isPressed) return Colors.white;
    if (_focusNode.hasFocus) return AppTheme.primaryText;
    if (_hasContent) return Colors.white;
    return AppTheme.primaryText;
  }

  List<BoxShadow> _getShadow() {
    if (!widget.enabled) {
      return [];
    }
    if (_isPressed) {
      return [
        BoxShadow(
          color: AppTheme.primaryAccent.withOpacity(0.25),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];
    }
    if (_focusNode.hasFocus) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];
    }
    if (_isHovering) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ];
    }

    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double borderWidth =
        (_isPressed || _focusNode.hasFocus || _hasContent) ? 2.0 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: widget.isRequired
                ? RichText(
                    text: TextSpan(
                      text: widget.labelText!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                      children: const [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: AppTheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    widget.labelText!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
        MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: SizedBox(
              height: 40,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                decoration: BoxDecoration(
                  boxShadow: _getShadow(),
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getBorderColor(),
                    width: borderWidth,
                  ),
                ),
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: widget.focusNode ?? _focusNode,
                  obscureText: widget.obscureText,
                  enabled: widget.enabled,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  autofillHints: widget.autofillHints,
                  textAlign: _getTextAligment(),
                  style: TextStyle(
                    color: _getTextColor(),
                    fontWeight: (!widget.enabled ||
                            (!_focusNode.hasFocus && !_isHovering))
                        ? FontWeight.w700
                        : FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.hintText,
                    // Remove o labelText daqui
                    // labelText: widget.labelText,
                    hintStyle: TextStyle(
                      color: _getTextColor(),
                      fontWeight: (!widget.enabled ||
                              (!_focusNode.hasFocus && !_isHovering))
                          ? FontWeight.w700
                          : FontWeight.normal,
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minHeight: 20,
                      minWidth: 32,
                      maxHeight: 20,
                      maxWidth: 32,
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minHeight: 20,
                      minWidth: 48,
                      maxHeight: 20,
                      maxWidth: 48,
                    ),
                    prefixIcon: widget.prefixIcon != null
                        ? Container(
                            margin: EdgeInsets.only(
                              left: 16.0 -
                                  borderWidth, // Ajusta margem baseado na borda
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                widget.prefixIcon,
                                color: _getTextColor(),
                                size: 20,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : null,
                    suffixIcon: widget.errorText != null &&
                            widget.suffixIcon == null
                        ? SizedBox(
                            height: 24,
                            width: 32,
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                PhosphorIcons.warning(),
                                color: Colors.red,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 1.5,
                                    offset: const Offset(-0.25, 1),
                                  ),
                                ],
                                size: 20,
                              ),
                            ),
                          )
                        : widget.suffixIcon != null
                            ? SizedBox(
                                height: 24,
                                width: 32,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: widget.suffixIcon is IconButton
                                      ? IconButton(
                                          icon:
                                              (widget.suffixIcon as IconButton)
                                                  .icon,
                                          onPressed:
                                              (widget.suffixIcon as IconButton)
                                                  .onPressed,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          splashRadius: 18,
                                        )
                                      : widget.suffixIcon,
                                ),
                              )
                            : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: widget.prefixIcon != null
                          ? 48.0 -
                              borderWidth // Ajusta padding baseado na borda
                          : 16.0 - borderWidth,
                      right: 16.0 - borderWidth,
                      top: 10.0 - (borderWidth / 2),
                      bottom: 10.0 - (borderWidth / 2),
                    ),
                  ),
                  onChanged: widget.onChanged,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
