import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class ClickableTextMedgo extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isDisabled;

  const ClickableTextMedgo({
    Key? key,
    required this.text,
    required this.onTap,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  State<ClickableTextMedgo> createState() => _ClickableTextMedgoState();
}

class _ClickableTextMedgoState extends State<ClickableTextMedgo> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double borderWidth = isPressed ? 2.0 : 1.0;
    final double paddingHorizontal = 16.0;
    final double paddingVertical = 8.0;

    return IntrinsicWidth(
      // Adiciona IntrinsicWidth como widget pai
      child: MouseRegion(
        cursor: widget.isDisabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        onEnter:
            widget.isDisabled ? null : (_) => setState(() => isHovered = true),
        onExit:
            widget.isDisabled ? null : (_) => setState(() => isHovered = false),
        child: GestureDetector(
          onTapDown: widget.isDisabled
              ? null
              : (_) => setState(() => isPressed = true),
          onTapUp: widget.isDisabled
              ? null
              : (_) {
                  setState(() => isPressed = false);
                  widget.onTap();
                },
          onTapCancel: widget.isDisabled
              ? null
              : () => setState(() => isPressed = false),
          child: Container(
            height: 36,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal -
                    (isPressed || isHovered ? borderWidth : 0),
                vertical: paddingVertical -
                    (isPressed || isHovered ? borderWidth : 0),
              ),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(20),
                border: _getBorder(),
                boxShadow: [
                  if (isPressed && isHovered)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2.0,
                      offset: const Offset(0, 1),
                    ),
                  if (isHovered)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5.0,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: _getTextColor(),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    shadows: [
                      if (!isHovered && !isPressed && !widget.isDisabled)
                        const Shadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (widget.isDisabled) return AppTheme.alternate;
    if (isPressed || isHovered) return AppTheme.lightSemiTransparent;
    return Colors.transparent;
  }

  Color _getTextColor() {
    if (widget.isDisabled) return AppTheme.secondaryText;
    return AppTheme.blueDark;
  }

  Border? _getBorder() {
    if (isPressed || isHovered) {
      return Border.all(
        color: AppTheme.salmon,
        width: isPressed ? 2.0 : 1.0,
      );
    }
    return null;
  }
}
