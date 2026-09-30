import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/shared/theme/app_colors.dart';

/// A line of alternating floats, like a swimming-pool lane rope. Used as the
/// underline of the holder's name on both card designs.
class LaneRope extends StatelessWidget {
  const LaneRope({
    super.key,
    required this.color,
    this.alternate,
    this.height = 2,
  });

  final Color color;

  /// Colour of every other float; a faded [color] when null.
  final Color? alternate;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _LaneRopePainter(
          color,
          alternate ?? color.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}

class _LaneRopePainter extends CustomPainter {
  const _LaneRopePainter(this.color, this.alternate);

  final Color color;
  final Color alternate;

  static const double _dash = 6;

  @override
  void paint(Canvas canvas, Size size) {
    final strong = Paint()..color = color;
    final light = Paint()..color = alternate;
    var x = 0.0;
    var i = 0;
    while (x < size.width) {
      final w = math.min(_dash, size.width - x);
      canvas.drawRect(
        Rect.fromLTWH(x, 0, w, size.height),
        i.isEven ? strong : light,
      );
      x += _dash;
      i++;
    }
  }

  @override
  bool shouldRepaint(_LaneRopePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.alternate != alternate;
}

/// A background pattern that hints at the issuer: a pool seen from the
/// starting blocks, diagonal stripes for a gym, ripples for a studio, dots
/// otherwise. [strength] scales its opacity: faint behind text, vivid when it
/// stands in for a picture.
class CardPatternPainter extends CustomPainter {
  const CardPatternPainter(this.category, {this.strength = 1});

  final IssuerCategory category;
  final double strength;

  double _alpha(double base) => (base * strength).clamp(0.0, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.onDark.withValues(alpha: _alpha(0.09))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    switch (category) {
      case IssuerCategory.pool:
        _pool(canvas, size);
      case IssuerCategory.gym:
        _stripes(canvas, size, paint);
      case IssuerCategory.studio:
      case IssuerCategory.beauty:
        _ripples(canvas, size, paint);
      case IssuerCategory.cafe:
      case IssuerCategory.restaurant:
      case IssuerCategory.shop:
      case IssuerCategory.other:
        _dotGrid(canvas, size);
    }
  }

  /// Lanes running away from the viewer towards a vanishing point on the
  /// left, each separated by a rope of floats, with the starting-block posts
  /// along the far wall.
  void _pool(Canvas canvas, Size size) {
    final vanishing = Offset(-size.width * 0.35, size.height * 0.3);
    const lanes = 8;
    final floatLight = Paint()
      ..color = AppColors.onDark.withValues(alpha: _alpha(0.16));
    final floatDark = Paint()
      ..color = AppColors.bandShadow.withValues(alpha: _alpha(0.18));
    final floor = Paint()
      ..color = AppColors.onDark.withValues(alpha: _alpha(0.05))
      ..strokeWidth = 1;

    for (var i = 0; i <= lanes; i++) {
      // Ropes fan out across the right edge, from top to bottom.
      final end = Offset(
        size.width * 1.05,
        -size.height * 0.1 + i * size.height * 1.3 / lanes,
      );
      canvas.drawLine(vanishing, end, floor);
      const floats = 26;
      for (var k = 4; k < floats; k++) {
        final t = k / floats;
        final p = Offset.lerp(vanishing, end, t)!;
        canvas.drawCircle(p, 0.6 + 2.2 * t, k.isEven ? floatLight : floatDark);
      }
    }

    // Starting-block posts along the right wall.
    final post = Paint()
      ..color = AppColors.bandShadow.withValues(alpha: _alpha(0.25))
      ..strokeWidth = 2.5;
    for (var i = 0; i < 6; i++) {
      final x = size.width * (0.18 + i * 0.16);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height * 0.22), post);
    }
  }

  void _stripes(Canvas canvas, Size size, Paint paint) {
    for (var x = -size.height; x < size.width; x += 22) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  void _ripples(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width * 0.9, size.height * 0.15);
    for (var r = 20.0; r < size.width; r += 22) {
      canvas.drawCircle(center, r, paint);
    }
  }

  void _dotGrid(Canvas canvas, Size size) {
    final dots = Paint()
      ..color = AppColors.onDark.withValues(alpha: _alpha(0.1));
    const step = 14.0;
    for (var y = step / 2; y < size.height; y += step) {
      for (var x = step / 2; x < size.width; x += step) {
        // Fade the grid out towards the bottom-left, under the text.
        final weight = (x / size.width + (1 - y / size.height)) / 2;
        canvas.drawCircle(Offset(x, y), 0.6 + 1.6 * weight, dots);
      }
    }
  }

  @override
  bool shouldRepaint(CardPatternPainter oldDelegate) =>
      oldDelegate.category != category || oldDelegate.strength != strength;
}
