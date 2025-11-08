import 'package:flutter/material.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';

class ContainerExpanded extends StatefulWidget {
  final bool expanded;
  final VoidCallback onClick;
  const ContainerExpanded({
    super.key,
    required this.expanded,
    required this.onClick,
  });

  @override
  State<ContainerExpanded> createState() => _ContainerExpandedState();
}

class _ContainerExpandedState extends State<ContainerExpanded> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClick();
      },
      child: Container(
        width: 100,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.expanded ? Strings.minimizar : Strings.expandir,
              style:
                  AppTheme.h5(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Icon(
              widget.expanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.redAccent,
            )
          ],
        ),
      ),
    );
  }
}
