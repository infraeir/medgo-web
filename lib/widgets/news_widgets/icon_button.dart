import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class CustomIconButtonMedGo extends StatefulWidget {
  final Icon icon;
  final Function()? onPressed;
  final double size;
  final Color borderColor;
  final Color hoverBackgroundColor;
  final Color pressedBackgroundColor;
  final Color pressedBorderColor;
  final double borderWidth;
  final double borderRadius;
  final String? tooltip; // Novo parâmetro para o tooltip
  final EdgeInsetsGeometry? padding; // Novo parâmetro para o padding
  final BoxConstraints? constraints; // Novo parâmetro para constraints
  final bool disabled; // Nova propriedade

  const CustomIconButtonMedGo({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.size = 50.0,
    this.borderColor = Colors.transparent,
    this.hoverBackgroundColor = const Color(0xFFD0E3EB),
    this.pressedBackgroundColor = const Color(0xFF78A6C8),
    this.pressedBorderColor = const Color(0xFFE67F75),
    this.borderWidth = 2.0,
    this.borderRadius = 30.0,
    this.tooltip, // Inicialização do tooltip
    this.padding, // Inicialização do padding
    this.constraints, // Inicialização dos constraints
    this.disabled = false, // Inicialização do disabled
  }) : super(key: key);

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButtonMedGo> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color currentBorderColor = widget.disabled
        ? AppTheme.secondaryText
        : isPressed
            ? widget.pressedBorderColor
            : (isHovered ? widget.pressedBorderColor : widget.borderColor);

    final Color currentBackgroundColor = widget.disabled
        ? AppTheme.alternate
        : isPressed
            ? widget.pressedBackgroundColor
            : (isHovered ? widget.hoverBackgroundColor : Colors.transparent);

    Widget buttonWidget = MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: widget.disabled ? null : (_) => setState(() => isHovered = true),
      onExit: widget.disabled ? null : (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTapDown:
            widget.disabled ? null : (_) => setState(() => isPressed = true),
        onTapUp: widget.disabled
            ? null
            : (_) {
                setState(() => isPressed = false);
                if (widget.onPressed != null) {
                  widget.onPressed!();
                }
              },
        onTapCancel:
            widget.disabled ? null : () => setState(() => isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: widget.constraints?.minWidth ?? widget.size * 0.8,
          height: widget.constraints?.minHeight ?? widget.size * 0.8,
          constraints: widget.constraints,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: currentBackgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: currentBorderColor,
              width: widget.borderWidth,
            ),
            boxShadow: !widget.disabled && isPressed
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: IconTheme(
              data: IconThemeData(
                color: widget.disabled
                    ? AppTheme.secondaryText
                    : (isPressed || isHovered
                        ? widget.borderColor
                        : widget.borderColor),
              ),
              child: widget.icon,
            ),
          ),
        ),
      ),
    );

    // Adicionando Tooltip se necessário e não estiver desabilitado
    if (!widget.disabled &&
        widget.tooltip != null &&
        widget.tooltip!.isNotEmpty) {
      buttonWidget = Tooltip(
        message: widget.tooltip!,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
