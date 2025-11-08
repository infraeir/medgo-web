import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class OutlineConsultationPrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final Icon? iconeRight;
  final Icon? iconeLeft;
  final String title;
  final bool isDisabled;
  final double? borderRadius;
  final Color? color;

  const OutlineConsultationPrimaryButton({
    super.key,
    required this.onTap,
    this.iconeRight,
    this.iconeLeft,
    required this.title,
    this.isDisabled = false,
    this.borderRadius,
    this.color,
  });

  @override
  State<OutlineConsultationPrimaryButton> createState() =>
      _OutlineConsultationPrimaryButtonState();
}

class _OutlineConsultationPrimaryButtonState
    extends State<OutlineConsultationPrimaryButton> {
  bool isHovered = false;
  bool isPressed = false;
  bool isTapped = false; // Novo estado para controlar o estado após o tap

  // Duração da animação
  final Duration animationDuration = const Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context) {
    // Determinando estados e cores
    final bool isDisabled = widget.isDisabled;

    // Cores do background
    final Color normalBgColor = widget.color ?? Colors.white;
    const Color hoverBgColor = Color(0xFF78A6C8);
    const Color pressBgColor = Color(0xFF004155);
    const Color tappedBgColor =
        Color(0xFF326789); // Nova cor para o estado após o tap

    // Determinando a cor atual do background
    Color currentBgColor;
    if (isDisabled) {
      currentBgColor = normalBgColor;
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
    final Color normalBorderColor = AppTheme.theme.primaryColor;
    const Color activeBorderColor = Color(0xFFE67F75);
    const Color disabledBorderColor = Colors.grey;
    final Color currentBorderColor = isDisabled
        ? disabledBorderColor
        : (isHovered || isPressed || isTapped
            ? activeBorderColor
            : normalBorderColor);

    // Cores do texto e ícone
    final Color normalTextColor = AppTheme.theme.primaryColor;
    const Color activeTextColor = Colors.white;
    const Color disabledTextColor = Colors.grey;
    final Color currentTextColor = isDisabled
        ? disabledTextColor
        : (isHovered || isPressed || isTapped
            ? activeTextColor
            : normalTextColor);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() {
        isHovered = false;
        // Resetar o estado isTapped ao sair do botão após um clique
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

          // Opcional: adicionar um timer para resetar o estado "tapped" após um tempo
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
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: currentBgColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.0),
            border: Border.all(
              color: currentBorderColor,
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: isDisabled
                  ? null
                  : () {
                      widget.onTap();
                      // Garantir que o estado tapped seja aplicado
                      setState(() {
                        isTapped = true;
                        // Resetar isTapped após um tempo
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted) {
                            setState(() {
                              if (!isHovered && !isPressed) isTapped = false;
                            });
                          }
                        });
                      });
                    },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.iconeLeft != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: AnimatedDefaultTextStyle(
                          duration: animationDuration,
                          style: TextStyle(color: currentTextColor),
                          child: IconTheme(
                            data: IconThemeData(color: currentTextColor),
                            child: widget.iconeLeft!,
                          ),
                        ),
                      ),
                    Flexible(
                      child: AnimatedDefaultTextStyle(
                        duration: animationDuration,
                        style: AppTheme.h5(
                          color: currentTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                        child: Text(
                          widget.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (widget.iconeRight != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: AnimatedDefaultTextStyle(
                          duration: animationDuration,
                          style: TextStyle(color: currentTextColor),
                          child: IconTheme(
                            data: IconThemeData(color: currentTextColor),
                            child: widget.iconeRight!,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
