import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'short_text_input.dart';

class SearchInputMedgo extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;
  final double iconSize;

  const SearchInputMedgo({
    Key? key,
    required this.controller,
    this.focusNode,
    this.hintText,
    this.enabled = true,
    required this.onChanged,
    this.onTap,
    this.iconSize = 20,
  }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<SearchInputMedgo> {
  @override
  Widget build(BuildContext context) {
    return ShortTextInputMedgo(
      controller: widget.controller,
      focusNode: widget.focusNode,
      hintText: widget.hintText ?? 'Pesquisar',
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      prefixIcon: PhosphorIcons.magnifyingGlass(
        PhosphorIconsStyle.bold,
      ),
      suffixIcon: widget.controller.text.isNotEmpty
          ? IconButton(
              onPressed: () {
                widget.controller.clear();
                widget.onChanged(widget.controller.text);
              },
              icon: Icon(
                PhosphorIcons.xCircle(),
                color: AppTheme.error,
                size: widget.iconSize,
                shadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
