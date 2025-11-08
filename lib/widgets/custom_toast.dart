import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback? closeCallback;

  const CustomToast({
    Key? key,
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.closeCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: backgroundColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              offset: const Offset(0, 10),
              blurRadius: 25,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: backgroundColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: backgroundColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: AppTheme.error,
                size: 24,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              onPressed: () {
                closeCallback?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
