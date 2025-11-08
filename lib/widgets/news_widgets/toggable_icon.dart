import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ToggleIconButtonMedgo extends StatefulWidget {
  final Function(bool isSelected)? onToggle;
  final double size;
  final bool isSelected;
  final bool disabled;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;

  const ToggleIconButtonMedgo({
    Key? key,
    required this.onToggle,
    required this.isSelected,
    this.size = 40.0,
    this.disabled = false,
    this.tooltip,
    this.padding,
    this.constraints,
  }) : super(key: key);

  @override
  _ToggleIconButtonState createState() => _ToggleIconButtonState();
}

class _ToggleIconButtonState extends State<ToggleIconButtonMedgo> {
  bool isHovered = false;
  bool isPressed = false;

  Color _getBorderColor() {
    if (widget.disabled) return AppTheme.secondaryText;
    if (isPressed) return AppTheme.salmon;
    if (isHovered) return AppTheme.salmon;
    return Colors.transparent;
  }

  Color _getBackgroundColor() {
    if (widget.disabled) return AppTheme.alternate;
    if (isPressed) return AppTheme.blueDark;
    if (isHovered) return AppTheme.blueLight;
    return Colors.transparent;
  }

  Color _getIconColor() {
    if (widget.disabled) return AppTheme.secondaryText;
    if (widget.isSelected) return AppTheme.primary;
    if (isHovered) return AppTheme.primary;
    return AppTheme.primary;
  }

  @override
  Widget build(BuildContext context) {
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
                if (widget.onToggle != null) {
                  widget.onToggle!(!widget.isSelected);
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
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: _getBorderColor(),
              width: 2.0,
            ),
          ),
          child: Center(
            child: Icon(
              widget.isSelected
                  ? PhosphorIcons.checkSquare(PhosphorIconsStyle.fill)
                  : PhosphorIcons.square(PhosphorIconsStyle.bold),
              size: widget.size * 0.6,
              color: _getIconColor(),
              shadows: !widget.disabled || !widget.isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2.0,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2.0,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );

    if (!widget.disabled && widget.tooltip != null) {
      buttonWidget = Tooltip(
        message: widget.tooltip!,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
