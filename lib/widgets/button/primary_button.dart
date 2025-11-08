import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget conteudo;
  final bool isDisabled;

  const PrimaryButton({
    super.key,
    required this.onTap,
    required this.conteudo,
    this.isDisabled = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Determinando a cor e largura da borda com base nos estados
    final Color borderColor = widget.isDisabled
        ? Colors.grey
        : (isHovered || isPressed)
            ? const Color(0xFFE67F75) // Cor da borda em hover e click
            : Colors.transparent; // Sem borda visível em estado normal

    final double borderWidth = isPressed
        ? 3.0 // Largura ao clicar
        : 2.0; // Largura normal e hover

    // Calculando o padding interno ajustado para manter o tamanho total constante
    final double verticalPadding = isPressed ? 5.0 : 6.0;

    // Construindo o botão
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) {
          setState(() => isPressed = false);
          if (!widget.isDisabled) {
            widget.onTap();
          }
        },
        onTapCancel: () => setState(() => isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: widget.isDisabled ? Colors.grey : AppTheme.primaryAccent,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            // Opcional: adicionar um leve efeito de sombra ao pressionar
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30.0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: widget.isDisabled ? null : widget.onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical:
                      verticalPadding, // Ajusta o padding vertical para compensar a borda
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.conteudo,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
