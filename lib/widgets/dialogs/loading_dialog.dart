import 'package:flutter/material.dart';
import 'package:medgo/widgets/load/load_ball.dart';

shoLoadingDialog({
  required BuildContext context,
  bool? barriedDismissible,
  String? title,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(title ?? "Carregando..."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(32),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimation(),
          ],
        ),
      );
    },
  );
}
