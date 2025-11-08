// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MultiSelectChipMedgo extends StatefulWidget {
  final List<Map<String, String>> items;
  final List<String> selectedIds;
  final Function(List<String> selectedIds) onSelectionChanged;
  final bool isDisabled;
  final double spacing;

  const MultiSelectChipMedgo({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onSelectionChanged,
    this.isDisabled = false,
    this.spacing = 8.0,
  });

  @override
  State<MultiSelectChipMedgo> createState() => _MultiSelectChipMedgoState();
}

class _MultiSelectChipMedgoState extends State<MultiSelectChipMedgo> {
  void _toggleSelection(String id) {
    if (widget.isDisabled) return;

    final List<String> newSelection = List.from(widget.selectedIds);

    if (newSelection.contains(id)) {
      newSelection.remove(id);
    } else {
      newSelection.add(id);
    }

    widget.onSelectionChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.spacing,
      children: widget.items.map((item) {
        final id = item['id'] ?? '';
        final title = item['title'] ?? '';
        final isSelected = widget.selectedIds.contains(id);

        return _MultiSelectChipItem(
          id: id,
          title: title,
          isSelected: isSelected,
          isDisabled: widget.isDisabled,
          onTap: () => _toggleSelection(id),
        );
      }).toList(),
    );
  }
}

class _MultiSelectChipItem extends StatefulWidget {
  final String id;
  final String title;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const _MultiSelectChipItem({
    required this.id,
    required this.title,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  State<_MultiSelectChipItem> createState() => _MultiSelectChipItemState();
}

class _MultiSelectChipItemState extends State<_MultiSelectChipItem> {
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

  static const double baseHorizontalPadding = 12.0;
  static const double baseVerticalPadding = 6.0;
  static const double defaultBorderWidth = 1.0;
  static const double pressedBorderWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    List<BoxShadow> boxShadow = [];
    Widget? iconWidget;

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

    final double currentBorderWidth =
        isPressed ? pressedBorderWidth : defaultBorderWidth;

    final double paddingAdjustment = currentBorderWidth - defaultBorderWidth;

    final adjustedPadding = EdgeInsets.symmetric(
      horizontal: baseHorizontalPadding - paddingAdjustment,
      vertical: baseVerticalPadding - paddingAdjustment,
    );

    if (widget.isDisabled) {
      backgroundColor = colorAlternate;
      borderColor = colorSecondaryText;
      textColor = colorSecondaryText;
      boxShadow = [];
      if (widget.isSelected) {
        iconWidget = Icon(
          PhosphorIcons.checkFat(PhosphorIconsStyle.bold),
          color: colorSecondaryText,
          size: 16,
        );
      }
    }
    // Pressed + Selected
    else if (isPressed && widget.isSelected) {
      backgroundColor = colorBlueDark.withOpacity(0.88);
      borderColor = colorSalmon;
      textColor = colorLightText;
      boxShadow = [shadowPressed];
      iconWidget = Icon(
        PhosphorIcons.xCircle(PhosphorIconsStyle.bold),
        color: AppTheme.error,
        size: 16,
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      );
    }
    // Selected Final
    else if (widget.isSelected) {
      backgroundColor = colorSelectedFinal;
      borderColor = Colors.transparent;
      textColor = Colors.white;
      boxShadow = [];
      iconWidget = Icon(
        PhosphorIcons.checkFat(PhosphorIconsStyle.bold),
        color: AppTheme.success,
        size: 16,
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      );
    }
    // Pressed (not selected)
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
      iconWidget = Icon(
        PhosphorIcons.checkFat(PhosphorIconsStyle.bold),
        color: AppTheme.success,
        size: 16,
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      );
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
          widget.onTap();
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
                _focusNode.unfocus();
              });
              widget.onTap();
            }
          },
          onTapCancel: () {
            if (!widget.isDisabled) setState(() => isPressed = false);
          },
          child: IntrinsicWidth(
            child: AnimatedContainer(
              duration: animationDuration,
              curve: Curves.easeInOut,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (iconWidget != null) ...[
                    iconWidget,
                    const SizedBox(width: 3),
                  ],
                  AnimatedDefaultTextStyle(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
