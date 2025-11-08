import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class ButtonPersonalizado extends StatefulWidget {
  final String title;
  final bool selected;
  final VoidCallback onClick;
  const ButtonPersonalizado({
    super.key,
    required this.title,
    required this.onClick,
    this.selected = false,
  });

  @override
  State<ButtonPersonalizado> createState() => _ButtonPersonalizadoState();
}

class _ButtonPersonalizadoState extends State<ButtonPersonalizado> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClick();
      },
      child: Container(
        width: 92,
        height: 38,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: widget.selected ? AppTheme.theme.primaryColorDark : AppTheme.theme.primaryColorLight,
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
            Text(
              widget.title,
              style:
                  AppTheme.h6(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
