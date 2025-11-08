import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class ButtonIcon extends StatefulWidget {
  final VoidCallback onClick;
  final String? title;
  final IconData? icon;
  final double width;
  final Color? color;
  final Color hoverBorderColor;

  const ButtonIcon({
    super.key,
    required this.onClick,
    this.title,
    this.icon,
    required this.width,
    this.color,
    this.hoverBorderColor = const Color(0xFFE67F75), // Cor da borda no hover
  });

  @override
  State<ButtonIcon> createState() => ButtonIconState();
}

class ButtonIconState extends State<ButtonIcon> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {
          widget.onClick();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150), // Animação suave
          width: widget.width,
          height: 38,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: widget.color ?? const Color(0xff004155),
            borderRadius: BorderRadius.circular(400),
            border: Border.all(
              color: isHovered 
                  ? widget.hoverBorderColor // Borda em hover
                  : (widget.color ?? const Color(0xff004155)), // Borda normal
              width: isHovered ? 2.0 : 1.0, // Borda ligeiramente mais grossa no hover
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 1.0,
                offset: Offset(0.2, .2),
                spreadRadius: 0.1,
                blurStyle: BlurStyle.normal,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 5,
              ),
              widget.title != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        widget.title ?? '',
                        style: AppTheme.h5(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    )
                  : const SizedBox.shrink(),
              Icon(
                widget.icon == null ? Icons.logout : widget.icon!,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}