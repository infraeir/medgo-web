import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math' as math;


class CustomTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final double maxWidth;

  const CustomTooltip({
    Key? key, 
    required this.child, 
    required this.message,
    this.maxWidth = 250,
  }) : super(key: key);

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEnterEvent event) => _showTooltip(context, event),
      onExit: (_) => _hideTooltip(),
      child: widget.child,
    );
  }

  OverlayEntry? _overlayEntry;

  void _showTooltip(BuildContext context, PointerEnterEvent event) {
    final overlay = Overlay.of(context);
    final position = event.position;
    
    // Obter o tamanho da tela
    final screenSize = MediaQuery.of(context).size;
    
    // Calcular a largura disponível à direita do cursor
    final availableWidthRight = screenSize.width - position.dx - 20;
    
    // Decidir se o tooltip deve aparecer à direita ou à esquerda
    final isShowingRight = availableWidthRight >= 100;
    
    // Calcular a largura máxima que o tooltip pode ter
    final tooltipMaxWidth = isShowingRight 
        ? math.min(widget.maxWidth, availableWidthRight)
        : math.min(widget.maxWidth, position.dx - 20);
    
    // Criação do overlay
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: isShowingRight ? position.dx + 10 : null,
        right: isShowingRight ? null : screenSize.width - position.dx + 10,
        top: position.dy,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            constraints: BoxConstraints(
              maxWidth: tooltipMaxWidth,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff57636C),
              borderRadius: BorderRadius.circular(4.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff57636C).withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Text(
              widget.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              softWrap: true,
              overflow: TextOverflow.visible, // Evita truncar o texto
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
  
  @override
  void dispose() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    super.dispose();
  }
}