import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LongTextInputMedgo extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool enabled;
  final String? errorText;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;

  const LongTextInputMedgo({
    Key? key,
    this.controller,
    this.hintText,
    this.enabled = true,
    this.errorText,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.minLines = 3,
    this.maxLines,
  }) : super(key: key);

  @override
  _LongTextInputState createState() => _LongTextInputState();
}

class _LongTextInputState extends State<LongTextInputMedgo> {
  late FocusNode _focusNode;
  bool _isHovering = false;
  bool _isPressed = false;
  double _currentHeight = 0.0;
  static const double _minResizableHeight = 70.0;
  static const double _estimatedLineHeight = 18.0;
  static const double _verticalContentPadding = 24.0;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    // Initialize height based on minLines
    final double calculatedHeight =
        (widget.minLines ?? 1) * _estimatedLineHeight + _verticalContentPadding;
    _currentHeight =
        calculatedHeight.clamp(_minResizableHeight, double.infinity);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  Color _getBorderColor() {
    if (!widget.enabled) return AppTheme.secondaryText;
    if (widget.errorText != null) return AppTheme.error;
    if (_isPressed) return AppTheme.salmon;
    if (_focusNode.hasFocus) return AppTheme.salmon;
    if (_isHovering) return AppTheme.salmon;
    return AppTheme.primary;
  }

  Color _getBackgroundColor() {
    if (!widget.enabled) return AppTheme.alternate;
    if (_isPressed) return AppTheme.blueDark;
    if (_focusNode.hasFocus) return Colors.white;
    if (_isHovering) return AppTheme.blueLight;
    return AppTheme.primaryBackground;
  }

  Color _getTextColor() {
    if (!widget.enabled) return AppTheme.secondaryText;
    if (_isPressed) return Colors.white;
    if (_focusNode.hasFocus) return AppTheme.primaryText;
    return AppTheme.primaryText;
  }

  List<BoxShadow> _getShadow() {
    if (!widget.enabled) return [];
    if (_isPressed) {
      return [
        BoxShadow(
          color: AppTheme.primaryAccent.withOpacity(0.25),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];
    }
    if (_focusNode.hasFocus) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];
    }
    if (_isHovering) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ];
    }
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool alignStart = _focusNode.hasFocus || _isHovering;
    const bool isResizable = true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: _currentHeight,
              decoration: BoxDecoration(
                boxShadow: _getShadow(),
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getBorderColor(),
                  width: (_isPressed || _focusNode.hasFocus) ? 2.0 : 1.0,
                ),
              ),
              child: Stack(
                children: [
                  TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    keyboardType:
                        widget.keyboardType ?? TextInputType.multiline,
                    inputFormatters: widget.inputFormatters,
                    minLines: null,
                    maxLines: null,
                    expands: isResizable,
                    textAlign: alignStart ? TextAlign.start : TextAlign.center,
                    style: TextStyle(
                      color: _getTextColor(),
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: _getTextColor(),
                        fontWeight: FontWeight.normal,
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minHeight: 20,
                        minWidth: 48,
                        maxHeight: 20,
                        maxWidth: 48,
                      ),
                      prefixIcon: widget.prefixIcon != null
                          ? Container(
                              margin: const EdgeInsets.only(left: 16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  widget.prefixIcon,
                                  color: _getTextColor(),
                                  size: 20,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : null,
                      suffixIcon: widget.suffixIcon,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: widget.prefixIcon != null ? 48.0 : 16.0,
                        right: 32.0,
                        top: 12.0,
                        bottom: 12.0,
                      ),
                    ),
                    onChanged: widget.onChanged,
                  ),
                  // Resize handle
                  if (isResizable)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.resizeDown,
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            setState(() {
                              _currentHeight =
                                  (_currentHeight + details.primaryDelta!)
                                      .clamp(
                                _minResizableHeight,
                                MediaQuery.of(context).size.height * 0.5,
                              );
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            child: PhosphorIcon(
                              PhosphorIcons.notches(),
                              color: _getTextColor(),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0),
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
