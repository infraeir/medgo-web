import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class TertiaryTextButtonMedGo extends StatefulWidget {
  final VoidCallback onTap;
  final String title;
  final bool isDisabled;

  const TertiaryTextButtonMedGo({
    super.key,
    required this.onTap,
    required this.title,
    this.isDisabled = false,
  });

  @override
  State<TertiaryTextButtonMedGo> createState() =>
      _TertiaryTextButtonMedGoState();
}

class _TertiaryTextButtonMedGoState extends State<TertiaryTextButtonMedGo> {
  bool isHovered = false;
  bool isPressed = false;
  bool isTapped = false; // Estado para controlar o efeito após o tap

  // Duração da animação
  final Duration animationDuration = const Duration(milliseconds: 150);

  Color colorIcon = AppTheme.primary;

  static const double baseHorizontalPadding = 32.0;
  static const double baseVerticalPadding = 8.0;
  static const double defaultBorderWidth = 1.0;
  static const double pressedBorderWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    // Determinando estados e cores
    final bool isDisabled = widget.isDisabled;

    // Determina a largura da borda atual
    final double currentBorderWidth =
        isPressed ? pressedBorderWidth : defaultBorderWidth;

    final double paddingAdjustment = currentBorderWidth - defaultBorderWidth;

    // Padding ajustado para manter o tamanho do componente constante
    final adjustedPadding = EdgeInsets.symmetric(
      horizontal: baseHorizontalPadding - paddingAdjustment,
      vertical: baseVerticalPadding - paddingAdjustment,
    );

    // Cores do background
    const Color normalBgColor = AppTheme.blueDark;
    const Color disabledBgColor = AppTheme.alternate;
    const Color hoverBgColor = Color(0xFF78A6C8);
    const Color pressBgColor = AppTheme.softBlue;
    const Color tappedBgColor =
        Color(0xFF326789); // Cor para o estado após o tap

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
    const Color normalBorderColor = AppTheme.lightTheme;
    const Color activeBorderColor = Color(0xFFE67F75);
    const Color disabledBorderColor = Colors.grey;
    final Color currentBorderColor = isDisabled
        ? disabledBorderColor
        : (isHovered || isPressed || isTapped
            ? activeBorderColor
            : normalBorderColor);

    // Cores do texto e ícone
    const Color normalTextColor = AppTheme.lightTheme;
    const Color activeTextColor = AppTheme.primary;
    const Color disabledTextColor = Colors.grey;
    final Color currentTextColor = isDisabled
        ? disabledTextColor
        : (isPressed || isTapped ? activeTextColor : normalTextColor);

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
          onTapDown: (_) => setState(() {
            isPressed = true;
            isTapped = false;
          }),
          onTapUp: (_) => setState(() {
            isPressed = false;
            isTapped = true;

            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                setState(() {
                  if (!isHovered && !isPressed) isTapped = false;
                });
              }
            });
          }),
          onTapCancel: () => setState(() {
            isPressed = false;
            isTapped = false;
          }),
          child: AnimatedContainer(
            duration: animationDuration,
            padding: adjustedPadding,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: currentBgColor,
              borderRadius: BorderRadius.circular(30.0),
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30.0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: isDisabled
                    ? null
                    : () {
                        widget.onTap();
                        setState(() {
                          isTapped = true;
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              setState(() {
                                if (!isHovered && !isPressed) isTapped = false;
                              });
                            }
                          });
                        });
                      },
                child: Center(
                  // Substitui Row por Center
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: currentTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
