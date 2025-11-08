import 'package:flutter/material.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';

class ButtonEdit extends StatefulWidget {
  final VoidCallback onClick;
  final bool onlyIcon;
  const ButtonEdit({
    super.key,
    required this.onClick,
    this.onlyIcon = false,
  });

  @override
  State<ButtonEdit> createState() => _ButtonEditState();
}

class _ButtonEditState extends State<ButtonEdit> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClick();
      },
      child: Container(
        width: widget.onlyIcon ? 70 : 120,
        height: 38,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppTheme.theme.primaryColorLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.redAccent),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 8.0,
              offset: Offset(2.0, 2.0),
              spreadRadius: 0.1,
              blurStyle: BlurStyle.normal,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit, color: Colors.redAccent),
            const SizedBox(
              width: 5,
            ),
            widget.onlyIcon
                ? const SizedBox.shrink()
                : Text(
                    Strings.editarTodos,
                    style: AppTheme.h5(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
          ],
        ),
      ),
    );
  }
}
