import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class SecondaryIconButtonMedGo extends StatefulWidget {
  final VoidCallback onTap;
  final String? title;
  final bool isDisabled;
  final Icon? leftIcon;
  final Icon? rightIcon;

  const SecondaryIconButtonMedGo({
    super.key,
    required this.onTap,
    this.title,
    this.isDisabled = false,
    this.leftIcon,
    this.rightIcon,
  });

  @override
  State<SecondaryIconButtonMedGo> createState() =>
      _SecondaryIconButtonMedGoState();
}

class _SecondaryIconButtonMedGoState extends State<SecondaryIconButtonMedGo> {
  bool isHovered = false;
  bool isPressed = false;
  bool isTapped = false;

  final Duration animationDuration = const Duration(milliseconds: 150);

  static const double baseHorizontalPadding = 10.0;
  static const double baseVerticalPadding = 8.0;
  static const double defaultBorderWidth = 1.0;
  static const double pressedBorderWidth = 2.0;
  static const double iconSpacing = 8.0;

  @override
  Widget build(BuildContext context) {
    // Determinando estados e cores
    final bool isDisabled = widget.isDisabled;

    // Determina a largura da borda atual
    final double currentBorderWidth =
        isPressed ? pressedBorderWidth : defaultBorderWidth;

    final double paddingAdjustment = currentBorderWidth - defaultBorderWidth;

    const double iconOnlySize = 40.0;

    final adjustedPadding = widget.title == null
        ? EdgeInsets.zero
        : EdgeInsets.symmetric(
            horizontal: baseHorizontalPadding - paddingAdjustment,
            vertical: baseVerticalPadding - paddingAdjustment,
          );

    // Cores do background
    const Color normalBgColor = AppTheme.blueLight;
    const Color disabledBgColor = AppTheme.alternate;
    const Color hoverBgColor = AppTheme.blueDark;
    const Color pressBgColor = Color(0xFF004155);
    const Color tappedBgColor = Color(0xFF326789);

    // Determinando a cor atual do background
    Color currentBgColor;
    if (isDisabled) {
      currentBgColor = disabledBgColor;
    } else if (isPressed) {
      currentBgColor = pressBgColor;
    } else if (isTapped) {
      currentBgColor = tappedBgColor;
    } else if (isHovered) {
      currentBgColor = hoverBgColor;
    } else {
      currentBgColor = normalBgColor;
    }

    // Cores da borda
    const Color normalBorderColor = AppTheme.primary;
    const Color activeBorderColor = Color(0xFFE67F75);
    const Color disabledBorderColor = Colors.grey;
    final Color currentBorderColor = isDisabled
        ? disabledBorderColor
        : (isHovered || isPressed || isTapped
            ? activeBorderColor
            : normalBorderColor);

    // Cores do texto e ícone
    const Color normalTextColor = AppTheme.primary;
    const Color activeTextColor = Colors.white;
    const Color disabledTextColor = Colors.grey;
    final Color currentTextColor = isDisabled
        ? disabledTextColor
        : (isHovered || isPressed || isTapped
            ? activeTextColor
            : normalTextColor);

    return IntrinsicWidth(
      child: MouseRegion(
        cursor: isDisabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() {
          isHovered = false;
          if (!isPressed) isTapped = false;
        }),
        child: GestureDetector(
          onTapDown: isDisabled
              ? null
              : (_) => setState(() {
                    isPressed = true;
                    isTapped = false;
                  }),
          onTapUp: isDisabled
              ? null
              : (_) {
                  setState(() {
                    isPressed = false;
                    isTapped = true;
                  });
                  widget.onTap();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      setState(() {
                        if (!isHovered && !isPressed) isTapped = false;
                      });
                    }
                  });
                },
          onTapCancel: isDisabled
              ? null
              : () => setState(() {
                    isPressed = false;
                    isTapped = false;
                  }),
          child: AnimatedContainer(
            duration: animationDuration,
            padding: adjustedPadding,
            width: widget.title == null
                ? iconOnlySize
                : null, // Largura fixa sem título
            height: widget.title == null
                ? iconOnlySize
                : null, // Altura fixa sem título
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: currentBgColor,
              borderRadius: BorderRadius.circular(
                  widget.title == null ? 20.0 : 30.0), // Ajusta border radius
              border: Border.all(
                color: currentBorderColor,
                width: currentBorderWidth,
              ),
              boxShadow: isDisabled
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.leftIcon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      color: currentTextColor,
                      size: 20,
                    ),
                    child: widget.leftIcon!,
                  ),
                  if (widget.title != null) const SizedBox(width: iconSpacing),
                ],
                if (widget.title != null)
                  Text(
                    widget.title!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: currentTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (widget.rightIcon != null) ...[
                  if (widget.title != null) const SizedBox(width: iconSpacing),
                  IconTheme(
                    data: IconThemeData(
                      color: currentTextColor,
                      size: 20,
                    ),
                    child: widget.rightIcon!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
