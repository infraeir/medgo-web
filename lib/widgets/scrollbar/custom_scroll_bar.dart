import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomScrollbar extends StatefulWidget {
  final Widget child;
  final ScrollController? controller;
  final double thickness;
  final double minThumbLength;
  final EdgeInsets trackMargin;
  final double rightMargin;
  final double bottomMargin;
  final Axis axis;

  const CustomScrollbar({
    super.key,
    required this.child,
    this.controller,
    this.thickness = 12.0,
    this.minThumbLength = 24.0, // Reduzido de 48.0 para 24.0
    this.trackMargin = const EdgeInsets.symmetric(vertical: 4.0),
    this.rightMargin = 4.0,
    this.bottomMargin = 4.0,
    this.axis = Axis.vertical,
  });

  @override
  State<CustomScrollbar> createState() => _CustomScrollbarState();
}

class _CustomScrollbarState extends State<CustomScrollbar> {
  late final ScrollController _controller;
  bool _ownsController = false;

  double _thumbSize = 0; // Pode ser altura (vertical) ou largura (horizontal)
  double _thumbPosition = 0; // Pode ser top (vertical) ou left (horizontal)
  bool _hovering = false;
  bool _dragging = false;
  bool _hasOverflow = false; // Indica se há overflow para mostrar scrollbar

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _ownsController = true;
      _controller = ScrollController();
    }
    _controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (!_controller.hasClients) {
      setState(() {
        _thumbSize = widget.minThumbLength;
        _thumbPosition = 0;
        _hasOverflow = false;
      });
      return;
    }

    final pos = _controller.position;
    final viewport = pos.viewportDimension;
    final maxExtent = pos.maxScrollExtent;
    final pixels = pos.pixels.clamp(0.0, maxExtent);

    // Detecta se há overflow (conteúdo maior que viewport)
    final hasOverflow = maxExtent > 0;

    if (viewport <= 0) {
      setState(() {
        _hasOverflow = false;
      });
      return;
    }

    final isVertical = widget.axis == Axis.vertical;

    // Calcular espaço disponível para o track (descontando margens)
    final trackMarginTotal = isVertical
        ? widget.trackMargin.top + widget.trackMargin.bottom
        : widget.trackMargin.left + widget.trackMargin.right;
    final availableTrackSize = math.max(0.0, viewport - trackMarginTotal);

    final contentExtent = viewport + maxExtent;
    double thumbSize = contentExtent == 0
        ? availableTrackSize
        : (viewport * availableTrackSize) / contentExtent;

    thumbSize = (thumbSize * 0.4)
        .clamp(widget.minThumbLength, availableTrackSize * 0.8);

    // Calcular posição do thumb dentro do track disponível
    final trackSize = math.max(0.0, availableTrackSize - thumbSize);
    final thumbPosition =
        (maxExtent == 0) ? 0.0 : (pixels / maxExtent) * trackSize;

    setState(() {
      _thumbSize = thumbSize;
      _thumbPosition = thumbPosition;
      _hasOverflow = hasOverflow;
    });
  }

  // converte delta do gesto para delta-scroll na posição real
  double _deltaToScrollDelta(double delta) {
    if (!_controller.hasClients) return 0.0;
    final pos = _controller.position;
    final maxExtent = pos.maxScrollExtent;
    final viewport = pos.viewportDimension;
    final trackAvailable = math.max(1.0, viewport - _thumbSize);
    if (maxExtent <= 0) return 0.0;
    return delta * (maxExtent / trackAvailable);
  }

  // cores conforme seu design
  Color get _trackColor => (_hovering || _dragging)
      ? const Color(0xff5CB0DE).withOpacity(0.16)
      : const Color(0xff5CB0DE).withOpacity(0.08);

  Color get _thumbColor => _dragging
      ? const Color(0xFF326789) // onPress (drag)
      : (_hovering ? const Color(0xFF78A6C8) : const Color(0xFFDFEEFF));

  Color get _borderColor => (_dragging || _hovering)
      ? const Color(0xFFE67F75)
      : const Color(0xFF004155);

  double get _borderWidth => _dragging ? 2.0 : 1.0;

  List<BoxShadow> get _thumbShadow {
    if (_dragging) {
      return [
        const BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          color: Color(0x4D000000),
        ),
      ];
    } else if (_hovering) {
      return [
        const BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          color: Color(0x80000000),
        ),
      ];
    } else {
      return [
        const BoxShadow(
          offset: Offset(0, 3),
          blurRadius: 5,
          color: Color(0x4D000000),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.axis == Axis.vertical;

    return LayoutBuilder(builder: (context, constraints) {
      final size = isVertical ? constraints.maxHeight : constraints.maxWidth;
      final startMargin =
          isVertical ? widget.trackMargin.top : widget.trackMargin.left;
      final endMargin =
          isVertical ? widget.trackMargin.bottom : widget.trackMargin.right;
      final trackSize = math.max(0.0, size - startMargin - endMargin);

      // garanta que o thumb não exceda o track
      final thumbSize = math.min(_thumbSize, trackSize);
      final maxThumbPosition = math.max(0.0, trackSize - thumbSize);
      final thumbPosition =
          startMargin + (_thumbPosition.clamp(0.0, maxThumbPosition));

      return Stack(
        children: [
          if (widget.controller == null)
            PrimaryScrollController(
                controller: _controller, child: widget.child)
          else
            widget.child,
          // Só mostra o scrollbar se houver overflow
          if (_hasOverflow) ...[
            // Track
            if (isVertical)
              Positioned(
                top: startMargin,
                bottom: endMargin,
                right: widget.rightMargin,
                width: widget.thickness,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _trackColor,
                      borderRadius: BorderRadius.circular(widget.thickness / 2),
                    ),
                  ),
                ),
              )
            else
              Positioned(
                left: startMargin,
                right: endMargin,
                bottom: widget.bottomMargin,
                height: widget.thickness,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _trackColor,
                      borderRadius: BorderRadius.circular(widget.thickness / 2),
                    ),
                  ),
                ),
              ),
            // Thumb
            if (isVertical)
              Positioned(
                top: thumbPosition,
                right: widget.rightMargin + 1,
                width: widget.thickness - 2,
                height: math.min(thumbSize, trackSize),
                child: _buildThumbWidget(isVertical: true),
              )
            else
              Positioned(
                left: thumbPosition,
                bottom: widget.bottomMargin + 1,
                width: math.min(thumbSize, trackSize),
                height: widget.thickness - 2,
                child: _buildThumbWidget(isVertical: false),
              ),
          ],
        ],
      );
    });
  }

  Widget _buildThumbWidget({required bool isVertical}) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (_) => setState(() => _dragging = true),
        onPanUpdate: (details) {
          final delta = isVertical ? details.delta.dy : details.delta.dx;
          final deltaScroll = _deltaToScrollDelta(delta);
          if (_controller.hasClients) {
            final newPos = (_controller.position.pixels + deltaScroll)
                .clamp(0.0, _controller.position.maxScrollExtent);
            _controller.jumpTo(newPos);
          }
        },
        onPanEnd: (_) => setState(() => _dragging = false),
        onPanCancel: () => setState(() => _dragging = false),
        child: Container(
          decoration: BoxDecoration(
            color: _thumbColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: _borderColor, width: _borderWidth),
            boxShadow: _thumbShadow,
          ),
        ),
      ),
    );
  }
}
