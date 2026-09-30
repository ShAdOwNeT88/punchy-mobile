import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';

/// Shows [front] or [back] with a 3D rotation around the vertical axis.
///
/// The widget is controlled: [showBack] decides the face at rest, and
/// [onFlipRequested] is called when the user taps the card or drags it past
/// half a turn. The owner toggles [showBack] in response.
class FlipCard extends StatefulWidget {
  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    required this.showBack,
    required this.onFlipRequested,
  });

  final Widget front;
  final Widget back;
  final bool showBack;
  final VoidCallback onFlipRequested;

  /// Depth of the perspective applied during the rotation.
  static const double _perspective = 0.0012;

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.flip,
    value: widget.showBack ? 1 : 0,
  );

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showBack != widget.showBack) _settle();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _settle() {
    _controller.animateTo(widget.showBack ? 1 : 0, curve: Curves.easeOutBack);
  }

  void _onDragUpdate(DragUpdateDetails details, double width) {
    // Dragging right-to-left turns the card towards its back, left-to-right
    // towards its front.
    final delta = details.primaryDelta ?? 0;
    _controller.value = (_controller.value - delta / width).clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails details) {
    final wantsBack = _controller.value > 0.5;
    if (wantsBack != widget.showBack) {
      widget.onFlipRequested();
    } else {
      _settle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          onTap: widget.onFlipRequested,
          onHorizontalDragUpdate: (d) => _onDragUpdate(d, width),
          onHorizontalDragEnd: _onDragEnd,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final angle = _controller.value * math.pi;
              final showingBack = angle > math.pi / 2;
              final transform = Matrix4.identity()
                ..setEntry(3, 2, FlipCard._perspective)
                ..rotateY(angle);
              return Transform(
                alignment: Alignment.center,
                transform: transform,
                child: showingBack
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: widget.back,
                      )
                    : widget.front,
              );
            },
          ),
        );
      },
    );
  }
}
