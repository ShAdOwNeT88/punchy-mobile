import 'package:flutter/material.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/widgets/card_appearance.dart';
import 'package:punchy/features/cards/widgets/signature_mark.dart';
import 'package:punchy/features/cards/widgets/stamp_mark.dart';
import 'package:punchy/l10n/app_localizations.dart';
import 'package:punchy/shared/theme/app_colors.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';
import 'package:punchy/shared/theme/app_typography.dart';

/// Back face: the grid of boxes stamped at each entry or payment.
class CardBack extends StatelessWidget {
  const CardBack({super.key, required this.card});

  final DigitalCard card;

  /// Columns of the grid for [slots] boxes: the fewest empty boxes, then the
  /// layout closest to three rows, as printed cards usually are (12 → 4×3,
  /// 10 → 5×2, 6 → 3×2).
  @visibleForTesting
  static int columnsFor(int slots) {
    var best = (slots / 3).ceil().clamp(1, slots);
    var bestScore = double.infinity;
    for (var c = 3; c <= 6; c++) {
      final rows = (slots / c).ceil();
      if (rows > 3) continue;
      final score = (rows * c - slots) * 10 + (3 - rows).abs();
      if (score < bestScore) {
        best = c;
        bestScore = score.toDouble();
      }
    }
    return slots < 3 ? slots : best;
  }

  static const double _gridLine = 1.2;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = CardAppearance.palette(card.style);
    final columns = columnsFor(card.totalSlots);
    final rows = (card.totalSlots / columns).ceil();
    final header = switch (card.program) {
      CardProgram.entries => l10n.cardEntriesHeader,
      CardProgram.monthly => l10n.cardMonthlyHeader,
      CardProgram.loyalty => l10n.cardLoyaltyHeader,
    };

    return CardCanvas(
      shadow: CardAppearance.shadow(palette),
      child: ColoredBox(
        color: card.design == CardDesign.paper
            ? AppColors.printWhite
            : AppColors.paper,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.paperInk, width: _gridLine),
            ),
            child: Column(
              children: [
                _Header(
                  title: header,
                  // Printed cards use plain black type, like the photo.
                  printed: card.design == CardDesign.paper,
                  ink: palette.ink,
                ),
                for (var r = 0; r < rows; r++)
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var c = 0; c < columns; c++)
                          Expanded(
                            child: _Slot(
                              card: card,
                              index: r * columns + c,
                              ink: palette.ink,
                              drawRight: c < columns - 1,
                              drawBottom: r < rows - 1,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.printed,
    required this.ink,
  });

  final String title;
  final bool printed;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.paperInk, width: 2.5),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: printed
            ? AppTypography.printSerif.copyWith(
                color: AppColors.paperInk,
                fontSize: AppFontSize.body,
                letterSpacing: 2,
              )
            : TextStyle(
                color: ink,
                fontSize: AppFontSize.small,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
      ),
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({
    required this.card,
    required this.index,
    required this.ink,
    required this.drawRight,
    required this.drawBottom,
  });

  final DigitalCard card;
  final int index;
  final Color ink;
  final bool drawRight;
  final bool drawBottom;

  static const _line = BorderSide(color: AppColors.paperInk, width: 1);
  static const double _rewardIconSize = 28;

  @override
  Widget build(BuildContext context) {
    final exists = index < card.totalSlots;
    final stamp = index < card.stamps.length ? card.stamps[index] : null;
    // On a loyalty card the last box is the reward, as on paper ones.
    final isRewardBox =
        card.program == CardProgram.loyalty && index == card.totalSlots - 1;
    return Container(
      decoration: BoxDecoration(
        color: exists ? null : AppColors.surfaceMuted,
        border: Border(
          right: drawRight ? _line : BorderSide.none,
          bottom: drawBottom ? _line : BorderSide.none,
        ),
      ),
      child: !exists
          ? null
          : Stack(
              alignment: Alignment.center,
              children: [
                if (stamp == null && isRewardBox)
                  Icon(Icons.redeem_rounded, color: ink, size: _rewardIconSize)
                else if (stamp == null)
                  _Watermark(card: card)
                else
                  switch (card.stampStyle) {
                    StampStyle.round => StampMark(
                      stamp: stamp,
                      program: card.program,
                      ink: ink,
                      // Vary the angle so the stamps look hand-made.
                      angle: ((index * 37) % 21 - 10) / 60,
                    ),
                    StampStyle.signature => SignatureMark(
                      stamp: stamp,
                      program: card.program,
                      seed: index,
                    ),
                  },
              ],
            ),
    );
  }
}

/// The faint issuer logo printed in every box of the paper card.
class _Watermark extends StatelessWidget {
  const _Watermark({required this.card});

  final DigitalCard card;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.55,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CardAppearance.emblemIcon(card.issuer),
                color: AppColors.paperWatermark,
                size: AppFontSize.title,
              ),
              Text(
                card.issuer.name,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  color: AppColors.paperWatermark,
                  fontSize: AppFontSize.micro,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
