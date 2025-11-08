import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/news_widgets/count_input/count_input_controller.dart';
import 'package:medgo/widgets/news_widgets/short_text_input.dart';

class CountInputMedgo extends StatefulWidget {
  final CountInputController controller;
  final Function(String value) onChanged;
  final Function(String value)? onChangedByIcon;
  final int? minValue;
  final int? maxValue;
  final bool disabled;
  final String? errorText;
  final FocusNode? focusNode;
  final String? label;

  const CountInputMedgo({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.onChangedByIcon,
    this.minValue,
    this.maxValue,
    this.disabled = false,
    this.errorText,
    this.focusNode,
    this.label,
  }) : super(key: key);

  @override
  _CountInputState createState() => _CountInputState();
}

class _CountInputState extends State<CountInputMedgo> {
  final TextEditingController _textController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _textController.text = widget.controller.value.toString();
    widget.controller.addListener(_updateTextField);
    _textController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_updateTextField);
    _textController.removeListener(_handleTextChange);
    _textController.dispose();
    super.dispose();
  }

  void _updateTextField() {
    if (_textController.text != widget.controller.value.toString()) {
      _textController.text = widget.controller.value.toString();
      _moveCursorToEnd();
    }
  }

  void _handleTextChange() {
    if (widget.disabled) return;

    String text = _textController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isEmpty) text = '0';

    int newVal = int.tryParse(text) ?? 0;
    if (widget.minValue != null) {
      newVal = newVal.clamp(
          widget.minValue!, widget.maxValue ?? double.infinity.toInt());
    } else if (widget.maxValue != null) {
      newVal = newVal.clamp(0, widget.maxValue!);
    }

    if (newVal != widget.controller.value) {
      widget.controller.value = newVal;
    }

    _onValueChanged(newVal.toString());
  }

  void _moveCursorToEnd() {
    final textLength = _textController.text.length;
    _textController.selection =
        TextSelection.fromPosition(TextPosition(offset: textLength));
  }

  void _onValueChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged(value);
    });
  }

  void _onChangedByIcon(String value) {
    if (widget.onChangedByIcon != null) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        widget.onChangedByIcon!(value);
      });
    }
  }

  double _calculateInputWidth() {
    final textLength = _textController.text.length;
    final labelWidth =
        widget.label != null ? (widget.label!.length * 8.0) + 16.0 : 0.0;
    final calculatedWidth = 20.0 + (textLength * 12.0) + labelWidth;
    return calculatedWidth.clamp(80.0, 250.0);
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        widget.disabled ? AppTheme.secondaryText : AppTheme.primary;

    final List<Shadow> shadowsIcons = widget.disabled
        ? []
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2.0,
              offset: const Offset(0, 1),
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconButtonMedGo(
              disabled: widget.disabled,
              icon: Icon(
                Icons.remove,
                size: 30,
                color: iconColor,
                shadows: shadowsIcons,
              ),
              onPressed: widget.disabled
                  ? null
                  : () {
                      widget.controller.decrement();
                      _updateTextField();
                      _onChangedByIcon(widget.controller.value.toString());
                    },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              width: _calculateInputWidth(),
              child: Stack(
                children: [
                  ShortTextInputMedgo(
                    controller: _textController,
                    focusNode: widget.focusNode,
                    enabled: !widget.disabled,
                    errorText: widget.errorText,
                    onChanged: (value) {
                      _handleTextChange();
                      // Força rebuild para recalcular a largurar
                      setState(() {});
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  if (widget.label != null)
                    Positioned(
                      right: 8,
                      top: 0,
                      bottom: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: IgnorePointer(
                          child: Text(
                            widget.label!,
                            style: const TextStyle(
                              color: AppTheme.softBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            CustomIconButtonMedGo(
              disabled: widget.disabled,
              icon: Icon(
                Icons.add,
                size: 30,
                color: iconColor,
                shadows: shadowsIcons,
              ),
              onPressed: widget.disabled
                  ? null
                  : () {
                      widget.controller.increment();
                      _updateTextField();
                      _onChangedByIcon(widget.controller.value.toString());
                    },
            ),
          ],
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: AppTheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
