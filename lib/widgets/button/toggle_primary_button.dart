import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medgo/themes/app_theme.dart';

class SwitchBarOption {
  final String name;
  final String id;
  final IconData? icon;
  final Color? color;
  final bool iconOnRight;

  const SwitchBarOption({
    required this.name,
    required this.id,
    this.icon,
    this.color,
    this.iconOnRight = false, // Padrão: ícone à esquerda
  });
}

class SwitchBarMedGo extends StatefulWidget {
  final List<SwitchBarOption> options;
  final String selectedId;
  final Function(String id) onPressed;
  final bool isDisabled;

  const SwitchBarMedGo({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  State<SwitchBarMedGo> createState() => _SwitchBarMedGoState();
}

class _SwitchBarMedGoState extends State<SwitchBarMedGo> {
  String? hoveredId;
  String? pressedId;
  String? focusedId;
  late Map<String, FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _initializeFocusNodes();
  }

  void _initializeFocusNodes() {
    _focusNodes = {};
    for (var option in widget.options) {
      _focusNodes[option.id] = FocusNode();
      _focusNodes[option.id]!.addListener(() {
        setState(() {
          if (_focusNodes[option.id]!.hasFocus) {
            focusedId = option.id;
          } else if (focusedId == option.id) {
            focusedId = null;
          }
        });
      });
    }
  }

  @override
  void didUpdateWidget(SwitchBarMedGo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.options != widget.options) {
      _disposeFocusNodes();
      _initializeFocusNodes();
    }
  }

  @override
  void dispose() {
    _disposeFocusNodes();
    super.dispose();
  }

  void _disposeFocusNodes() {
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    _focusNodes.clear();
  }

  final Duration animationDuration = const Duration(milliseconds: 150);

  // Define as medidas base seguindo o padrão do InputChipMedgo
  static const double baseHorizontalPadding = 12.0;
  static const double baseVerticalPadding = 8.0;
  static const double defaultBorderWidth = 1.0;
  static const double pressedBorderWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.options.asMap().entries.map((entry) {
            int index = entry.key;
            SwitchBarOption option = entry.value;
            bool isFirst = index == 0;
            bool isLast = index == widget.options.length - 1;

            return _buildButton(
              option: option,
              isFirst: isFirst,
              isLast: isLast,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildButton({
    required SwitchBarOption option,
    required bool isFirst,
    required bool isLast,
  }) {
    final bool isSelected = widget.selectedId == option.id;
    final bool isHovered = hoveredId == option.id;
    final bool isPressed = pressedId == option.id;
    final bool isFocused = focusedId == option.id;

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    List<BoxShadow> boxShadow = [];

    // Paleta baseada no InputChipMedgo
    const Color colorPrimary = Color(0xFF004155);
    const Color colorBlueLight = Color(0xFF78A6C8);
    const Color colorBlueDark = Color(0xFF326789);
    const Color colorSelectedFinal = Color(0xFF326789);
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

    // Calcula o ajuste do padding
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
    else if (isPressed && isSelected) {
      backgroundColor = colorBlueDark.withOpacity(0.88);
      borderColor = colorSalmon;
      textColor = colorLightText;
      boxShadow = [shadowPressed];
    }
    // Selected Final (novo visual)
    else if (isSelected) {
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
      focusNode: _focusNodes[option.id],
      canRequestFocus: !widget.isDisabled,
      onKey: (node, event) {
        if (!widget.isDisabled &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          widget.onPressed(option.id);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        cursor: widget.isDisabled
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        onEnter: (_) {
          if (!widget.isDisabled) setState(() => hoveredId = option.id);
        },
        onExit: (_) {
          if (!widget.isDisabled) setState(() => hoveredId = null);
        },
        child: GestureDetector(
          onTapDown: (_) {
            if (!widget.isDisabled) setState(() => pressedId = option.id);
          },
          onTapUp: (_) async {
            if (!widget.isDisabled) {
              setState(() {
                pressedId = null;
                _focusNodes[option.id]!.unfocus();
              });
              widget.onPressed(option.id);
            }
          },
          onTapCancel: () {
            if (!widget.isDisabled) setState(() => pressedId = null);
          },
          child: AnimatedContainer(
            duration: animationDuration,
            curve: Curves.easeInOut,
            padding: adjustedPadding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: isFirst ? const Radius.circular(20) : Radius.zero,
                bottomLeft: isFirst ? const Radius.circular(20) : Radius.zero,
                topRight: isLast ? const Radius.circular(20) : Radius.zero,
                bottomRight: isLast ? const Radius.circular(20) : Radius.zero,
              ),
              border: Border.all(
                color: borderColor,
                width: currentBorderWidth,
              ),
              boxShadow: boxShadow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone à esquerda
                if (option.icon != null && !option.iconOnRight) ...[
                  Icon(
                    option.icon,
                    color: option.color ?? textColor,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                ],
                AnimatedDefaultTextStyle(
                  duration: animationDuration,
                  style: AppTheme.h5(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                  child: Text(
                    option.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Ícone à direita
                if (option.icon != null && option.iconOnRight) ...[
                  const SizedBox(width: 6),
                  Icon(
                    option.icon,
                    color: option.color ?? textColor,
                    size: 20,
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
