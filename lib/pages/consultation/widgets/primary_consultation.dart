import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class PrimaryConsultationButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget conteudo;

  const PrimaryConsultationButton({super.key, required this.onTap, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(AppTheme.theme.primaryColor),
        minimumSize: MaterialStateProperty.all(const Size(20, 44)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      onPressed: onTap,
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
          overflow: TextOverflow.ellipsis,
        ),
        child: conteudo,
      ),
    );
  }
}
