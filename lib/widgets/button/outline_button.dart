import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class OutlinePrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final IconData? iconeRight;
  final IconData? iconeLeft;
  final String title;
  final bool isDisabled;
  final double? borderRadius;
  final Color? color;
  final Color? iconColor;

  const OutlinePrimaryButton({
    super.key,
    required this.onTap,
    this.iconeRight,
    this.iconeLeft,
    required this.title,
    this.isDisabled = false,
    this.borderRadius,
    this.color,
    this.iconColor,
  });

  @override
  State<OutlinePrimaryButton> createState() => _OutlinePrimaryButtonState();
}

class _OutlinePrimaryButtonState extends State<OutlinePrimaryButton> {
  bool isHovered = false;
  bool isPressed = false;
  bool isTapped = false; // Estado para controlar o efeito após o tap

  // Duração da animação
  final Duration animationDuration = const Duration(milliseconds: 150);

  Color colorIcon = AppTheme.primary;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.iconColor != null) {
      setState(() {
        colorIcon = widget.iconColor!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determinando estados e cores
    final bool isDisabled = widget.isDisabled;

    // Cores do background
    final Color normalBgColor = widget.color ?? Colors.white;
    const Color hoverBgColor = Color(0xFF78A6C8);
    const Color pressBgColor = Color(0xFF004155);
    const Color tappedBgColor =
        Color(0xFF326789); // Cor para o estado após o tap

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

          // Adicionar um timer para resetar o estado "tapped" após um tempo
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ]),
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
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize:
                      MainAxisSize.min, // Mantém o botão do tamanho do conteúdo
                  children: [
                    if (widget.iconeLeft != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: AnimatedDefaultTextStyle(
                          duration: animationDuration,
                          style: TextStyle(color: currentTextColor),
                          child: IconTheme(
                            data: IconThemeData(color: currentTextColor),
                            child: Icon(
                              widget.iconeLeft!,
                              color:
                                  isPressed ? Colors.white : widget.iconColor,
                            ),
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
                        padding: const EdgeInsets.only(left: 5),
                        child: AnimatedDefaultTextStyle(
                          duration: animationDuration,
                          style: TextStyle(color: currentTextColor),
                          child: IconTheme(
                              data: IconThemeData(color: currentTextColor),
                              child: Icon(
                                widget.iconeRight!,
                                color:
                                    isPressed ? Colors.white : widget.iconColor,
                              )),
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
