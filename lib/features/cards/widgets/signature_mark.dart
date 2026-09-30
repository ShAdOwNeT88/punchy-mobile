import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/shared/theme/app_colors.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';
import 'package:punchy/shared/ui/formatters.dart';

/// A box signed by hand, as staff do on paper cards: the operator's initials
/// in pen with a flourish, and the date written small underneath.
class SignatureMark extends StatelessWidget {
  const SignatureMark({
    super.key,
    required this.stamp,
    required this.program,
    this.seed = 0,
  });

  final CardStamp stamp;
  final CardProgram program;

  /// Varies angle and flourish so no two signatures look identical.
  final int seed;

  static const double _initialsSize = 22;
  static const double _flourishHeight = 10;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final date = switch (program) {
      CardProgram.monthly => Formatters.monthAbbreviation(
        stamp.period ?? stamp.date,
        locale,
      ),
      CardProgram.entries ||
      CardProgram.loyalty => Formatters.dayMonth(stamp.date, locale),
    };
    final initials = stamp.operatorInitials;

    return Transform.rotate(
      angle: -0.18 + (seed % 5) * 0.05,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (initials != null)
            Text(
              initials,
              style: const TextStyle(
                color: AppColors.penInk,
                fontSize: _initialsSize,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
                height: 1,
                letterSpacing: -1,
              ),
            ),
          SizedBox(
            width: _initialsSize * 2.4,
            height: _flourishHeight,
            child: CustomPaint(painter: _FlourishPainter(seed)),
          ),
          Text(
            date,
            style: const TextStyle(
              color: AppColors.penInk,
              fontSize: AppFontSize.micro,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// A looping pen stroke, the tail of a signature.
class _FlourishPainter extends CustomPainter {
  const _FlourishPainter(this.seed);

  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()
      ..color = AppColors.penInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;
    final loops = 2 + seed % 2;
    final path = Path()..moveTo(0, size.height * 0.6);
    const steps = 40;
    for (var i = 1; i <= steps; i++) {
      final t = i / steps;
      final x = size.width * t;
      final y =
          size.height *
          (0.5 + 0.4 * math.sin(t * loops * 2 * math.pi) * (1 - t * 0.5));
      path.lineTo(x, y);
    }
    canvas.drawPath(path, pen);
  }

  @override
  bool shouldRepaint(_FlourishPainter oldDelegate) => oldDelegate.seed != seed;
}
