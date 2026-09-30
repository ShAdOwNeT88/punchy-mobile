import 'package:flutter/material.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';
import 'package:punchy/shared/ui/formatters.dart';

/// A round rubber-stamp mark: the month (monthly cards) or the day (entry
/// cards), and the initials of whoever stamped it.
class StampMark extends StatelessWidget {
  const StampMark({
    super.key,
    required this.stamp,
    required this.program,
    required this.ink,
    this.angle = 0,
  });

  final CardStamp stamp;
  final CardProgram program;
  final Color ink;

  /// Rotation in radians.
  final double angle;

  static const double _diameter = 44;
  static const double _ring = 2;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final label = switch (program) {
      CardProgram.monthly => Formatters.monthAbbreviation(
        stamp.period ?? stamp.date,
        locale,
      ),
      CardProgram.entries ||
      CardProgram.loyalty => Formatters.dayMonth(stamp.date, locale),
    };
    final initials = stamp.operatorInitials;

    return Transform.rotate(
      angle: angle,
      child: Container(
        width: _diameter,
        height: _diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ink.withValues(alpha: 0.08),
          border: Border.all(color: ink.withValues(alpha: 0.85), width: _ring),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: ink,
                fontSize: AppFontSize.caption,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            if (initials != null)
              Text(
                initials,
                style: TextStyle(
                  color: ink,
                  fontSize: AppFontSize.micro,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
