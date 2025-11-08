import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/short_text_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DateInputMedgo extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<DateTime?>? onDateChanged;
  final FocusNode? focusNode;
  final bool isRequired;

  const DateInputMedgo({
    Key? key,
    this.controller,
    this.hintText = 'DD/MM/YYYY',
    this.labelText,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.onDateChanged,
    this.focusNode,
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<DateInputMedgo> createState() => _DateInputMedgoState();
}

class _DateInputMedgoState extends State<DateInputMedgo> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isValidDate = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_validateDate);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_validateDate);
    _focusNode.removeListener(_onFocusChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  bool get _hasContent => _controller.text.isNotEmpty;

  Color _getIconColor() {
    if (!widget.enabled) return AppTheme.secondaryText;
    if (_isPressed) return Colors.white;
    if (_focusNode.hasFocus) return AppTheme.primary;
    if (_hasContent) return Colors.white;
    return AppTheme.primary;
  }

  void _validateDate() {
    final text = _controller.text.replaceAll('/', '');

    // Só valida se tiver 8 dígitos (ddmmyyyy)
    if (text.length == 8) {
      try {
        final day = int.parse(text.substring(0, 2));
        final month = int.parse(text.substring(2, 4));
        final year = int.parse(text.substring(4, 8));

        // Valida ranges básicos
        if (day < 1 || day > 31 || month < 1 || month > 12 || year < 1900) {
          setState(() {
            _isValidDate = false;
          });
          widget.onDateChanged?.call(null);
          return;
        }

        // Tenta criar a data
        final date = DateTime(year, month, day);

        // Valida se a data é válida (ex: 31/02 seria inválido)
        if (date.day == day && date.month == month && date.year == year) {
          setState(() {
            _isValidDate = true;
          });
          widget.onDateChanged?.call(date);
        } else {
          setState(() {
            _isValidDate = false;
          });
          widget.onDateChanged?.call(null);
        }
      } catch (e) {
        setState(() {
          _isValidDate = false;
        });
        widget.onDateChanged?.call(null);
      }
    } else {
      setState(() {
        _isValidDate = false;
      });
      widget.onDateChanged?.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: ShortTextInputMedgo(
          controller: _controller,
          hintText: widget.hintText,
          labelText: widget.labelText,
          enabled: widget.enabled,
          errorText: widget.errorText,
          focusNode: _focusNode,
          isRequired: widget.isRequired,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _DateInputFormatter(),
            LengthLimitingTextInputFormatter(10),
          ],
          suffixIcon: Icon(
            _isValidDate
                ? PhosphorIcons.calendar(PhosphorIconsStyle.regular)
                : PhosphorIcons.calendarPlus(PhosphorIconsStyle.bold),
            color: _getIconColor(),
            size: 24,
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          onChanged: (value) {
            widget.onChanged?.call(value);
          },
        ),
      ),
    );
  }
}

/// Formatter que adiciona automaticamente as barras na data
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      // Adiciona '/' após o dia (posição 2) e após o mês (posição 5)
      if ((i == 1 || i == 3) && i < text.length - 1) {
        buffer.write('/');
      }
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
