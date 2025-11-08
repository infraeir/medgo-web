import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medgo/themes/app_theme.dart';

class InputIconChipMedgo extends StatefulWidget {
  final bool selectedChip;
  final String title;
  final Icon? icon;
  final double? width;
  final bool isDisabled;
  final Function(bool selected) onSelected;

  const InputIconChipMedgo({
    super.key,
    required this.selectedChip,
    required this.onSelected,
    required this.title,
    this.icon,
    this.width,
    this.isDisabled = false,
  });

  @override
  State<InputIconChipMedgo> createState() => _InputIconChipMedgoState();
}

class _InputIconChipMedgoState extends State<InputIconChipMedgo> {
  bool isHovered = false;
  bool isPressed = false;
  bool isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  final Duration animationDuration = const Duration(milliseconds: 150);

  // Define as medidas base que representam o padding desejado
  // quando a borda está na sua largura padrão (mais fina).
  static const double baseHorizontalPadding = 12.0;
  static const double baseVerticalPadding = 8.0;
  static const double defaultBorderWidth = 1.0;
  static const double pressedBorderWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    List<BoxShadow> boxShadow = [];

    // Paleta baseada na imagem
    const Color colorPrimary = Color(0xFF004155);
    const Color colorBlueLight = Color(0xFF78A6C8);
    const Color colorBlueDark = Color(0xFF326789);
    const Color colorSelectedFinal = Color(0xFF003E4C);
    const Color colorSalmon = Color(0xFFE67F75);
    const Color colorLightText = Color(0xFFDAEAEF);
    const Color colorAlternate = Color(0xFFE0E3E7);
    const Color colorSecondaryText = Color(0xFF57636C);

    const shadowPressed = BoxShadow(
      color: Color(0x4D1D2429),
      blurRadius: 4,
      offset: Offset(0, 2),
    );

    // Determina a largura da borda atual
    final double currentBorderWidth =
        isPressed ? pressedBorderWidth : defaultBorderWidth;

    // Calcula o ajuste do padding. Se a borda aumenta, o padding interno deve diminuir
    // para que o tamanho total do componente permaneça o mesmo.
    // A diferença é aplicada em ambos os lados (horizontal e vertical),
    // então a largura total da borda muda em 2 * (diferença da largura).
    // O padding deve diminuir por essa mesma diferença.
    final double paddingAdjustment = currentBorderWidth - defaultBorderWidth;

    // Padding ajustado para manter o tamanho do componente constante
    final adjustedPadding = EdgeInsets.symmetric(
      horizontal: baseHorizontalPadding - paddingAdjustment,
      vertical: baseVerticalPadding - paddingAdjustment,
    );

    if (widget.isDisabled) {
      backgroundColor = colorAlternate;
      borderColor = colorSecondaryText;
      textColor = colorSecondaryText;
      boxShadow = [];
    }
    // Pressed + Selected
    else if (isPressed && widget.selectedChip) {
      backgroundColor = colorBlueDark.withOpacity(0.88);
      borderColor = colorSalmon;
      textColor = colorLightText;
      boxShadow = [shadowPressed];
    }
    // Selected Final (novo visual)
    else if (widget.selectedChip) {
      backgroundColor = colorSelectedFinal;
      borderColor = Colors.transparent;
      textColor = Colors.white;
      boxShadow = [];
    }
    // Pressed
    else if (isPressed) {
      backgroundColor = colorPrimary;
      borderColor = colorSalmon;
      textColor = colorLightText;
      boxShadow = [
        const BoxShadow(
          blurRadius: 2,
          offset: Offset(0, 1),
          color: Color(0x80000000),
        ),
      ];
    }
    // Hover
    else if (isHovered) {
      backgroundColor = colorBlueLight;
      borderColor = colorSalmon;
      textColor = Colors.white;
      boxShadow = [
        const BoxShadow(
          blurRadius: 5,
          offset: Offset(0, 3),
          color: Color(0x4d000000),
        ),
        const BoxShadow(
          blurRadius: 2,
          offset: Offset(0, 1),
          color: Color(0x80000000),
        ),
      ];
    }
    // Default
    else {
      backgroundColor = AppTheme.primaryBackground;
      borderColor = colorPrimary;
      textColor = colorPrimary;
      boxShadow = [
        const BoxShadow(
          blurRadius: 5,
          offset: Offset(0, 3),
          color: Color(0x4d000000),
        ),
      ];
    }

    if (isFocused && !widget.isDisabled) {
      boxShadow = [
        const BoxShadow(
          blurRadius: 5,
          offset: Offset(0, 3),
          color: Color(0x4d000000),
        ),
        ...boxShadow,
      ];
      backgroundColor = colorBlueLight;
      borderColor = colorSalmon;
    }

    return Focus(
      focusNode: _focusNode,
      canRequestFocus: !widget.isDisabled,
      onKey: (node, event) {
        if (!widget.isDisabled &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          widget.onSelected(!widget.selectedChip);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        cursor: widget.isDisabled
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        onEnter: (_) {
          if (!widget.isDisabled) setState(() => isHovered = true);
        },
        onExit: (_) {
          if (!widget.isDisabled) setState(() => isHovered = false);
        },
        child: GestureDetector(
          onTapDown: (_) {
            if (!widget.isDisabled) setState(() => isPressed = true);
          },
          onTapUp: (_) async {
            if (!widget.isDisabled) {
              setState(() {
                isPressed = false;
                // Removemos o foco ao clicar
                _focusNode.unfocus();
              });
              widget.onSelected(!widget.selectedChip);
            }
          },
          onTapCancel: () {
            if (!widget.isDisabled) setState(() => isPressed = false);
          },
          child: IntrinsicWidth(
            child: AnimatedContainer(
              duration: animationDuration,
              curve: Curves.easeInOut,
              width: widget.width,
              constraints: const BoxConstraints(minWidth: 30.0),
              padding: adjustedPadding,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: borderColor,
                  width: currentBorderWidth,
                ),
                boxShadow: boxShadow,
              ),
              child: Row(
                children: [
                  if (widget.icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: widget.icon!,
                    ),
                  Center(
                    child: AnimatedDefaultTextStyle(
                      duration: animationDuration,
                      style: AppTheme.h5(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
