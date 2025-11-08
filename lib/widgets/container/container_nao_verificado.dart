import 'package:flutter/material.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';

class NaoVerificadoContainer extends StatefulWidget {
  final VoidCallback onClick;
  const NaoVerificadoContainer({
    super.key,
    required this.onClick,
  });

  @override
  State<NaoVerificadoContainer> createState() => _NaoVerificadoContainerState();
}

class _NaoVerificadoContainerState extends State<NaoVerificadoContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClick();
      },
      child: Container(
        width: 110,
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
            Text(
              Strings.naoVerificado,
              style:
                  AppTheme.h5(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
