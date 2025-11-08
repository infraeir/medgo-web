import 'package:flutter/material.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/widgets/button/outline_button.dart';
import 'package:medgo/widgets/button/primary_button.dart';

showTheDialog({
  required BuildContext context,
  bool? barrierDismissible,
  Widget? body,
  String? title,
  String? actionButtonText,
  String? actionButtonText2,
  required VoidCallback onActionButtonPressed,
  VoidCallback? onClosedPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? false,
    builder: (_) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title ?? "Carregando..."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(32),
        content: body,
        actions: [
          SizedBox(
            width: 200,
            child: OutlinePrimaryButton(
              onTap: () {
                if(onClosedPressed != null) {
                  onClosedPressed();
                }
                Navigator.of(context).pop(false);
              },
              title: actionButtonText2 ?? Strings.cancelar,
            ),
          ),
          if (actionButtonText != null)
            SizedBox(
              width: 200,
              child: PrimaryButton(
                onTap: onActionButtonPressed,
                conteudo: Text(
                  actionButtonText,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      );
    },
  );
}
