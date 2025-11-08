import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class PrimaryIconButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Nullable para o estado disabled
  final IconData? leftIcon;
  final IconData? rightIcon;

  const PrimaryIconButton({
    super.key,
    required this.text,
    required this.onPressed, // Passe null para desabilitar o botão
    this.leftIcon,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        // 1. Formato (Oval)
        shape: WidgetStateProperty.all(const StadiumBorder()),

        // 2. Preenchimento interno do botão
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),

        // 3. Cor de fundo (Background Color)
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppTheme.alternate;
            }
            if (states.contains(WidgetState.pressed)) {
              return AppTheme.primaryAccent;
            }
            if (states.contains(WidgetState.hovered)) {
              return AppTheme.blueLight;
            }
            return AppTheme.primaryAccent;
          },
        ),

        // 4. Cor do texto e ícones (Foreground Color)
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppTheme.secondaryText;
            }
            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.hovered)) {
              return AppTheme.lightTheme;
            }
            return AppTheme.primary;
          },
        ),

        // 5. Cor da Borda (Side)
        side: WidgetStateProperty.resolveWith<BorderSide?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.hovered)) {
              return BorderSide(
                color: AppTheme.salmon,
                width: states.contains(WidgetState.pressed) ? 2.0 : 1.0,
              );
            }
            return const BorderSide(
              color: AppTheme.primary,
              width: 1.0,
            );
          },
        ),

        // 6. Elevação (Shadow height)
        elevation: WidgetStateProperty.resolveWith<double?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return 1.0; // Sombra sutil no disabled
            }
            if (states.contains(WidgetState.pressed)) {
              return 2.0; // Sombra menor no press
            }
            if (states.contains(WidgetState.hovered)) {
              return 6.0; // Sombra maior no hover
            }
            return 4.0; // Sombra padrão
          },
        ),

        // 7. Cor da Sombra (Shadow Color)
        // ignore: deprecated_member_use
        shadowColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.black.withOpacity(0.3); // Sombra bem sutil
            }
            if (states.contains(MaterialState.pressed)) {
              return Colors.black.withOpacity(0.3);
            }
            // Sombra padrão para hover e default
            return Colors.black.withOpacity(0.3);
          },
        ),

        // 8. Cor do efeito de clique (overlay)
        overlayColor: WidgetStateProperty.all(
            Colors.transparent), // Desabilita o ripple padrão se não quiser
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Para que o Row ocupe apenas o espaço necessário
        children: [
          if (leftIcon != null) ...[
            Icon(leftIcon, size: 20), // Tamanho do ícone
            const SizedBox(width: 8.0), // Espaçamento entre ícone e texto
          ],
          Text(
            text,
          ),
          if (rightIcon != null) ...[
            const SizedBox(width: 8.0), // Espaçamento entre texto e ícone
            Icon(rightIcon, size: 20),
          ],
        ],
      ),
    );
  }
}
