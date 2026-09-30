import 'package:flutter/material.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/widgets/card_appearance.dart';
import 'package:punchy/features/cards/widgets/card_decorations.dart';
import 'package:punchy/l10n/app_localizations.dart';
import 'package:punchy/shared/theme/app_colors.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';
import 'package:punchy/shared/theme/app_typography.dart';

/// Front of a [CardDesign.paper] card: a white printed card with a picture
/// band on top carrying the number box, the logo and the "Info" bubble, and
/// the holder written by hand on the lines below.
class PaperCardFront extends StatelessWidget {
  const PaperCardFront({super.key, required this.card});

  final DigitalCard card;

  /// Geometry of the printed layout, in design pixels (see [CardCanvas]).
  static const double _margin = 10;
  static const double _bandHeight = 128;

  @override
  Widget build(BuildContext context) {
    final palette = CardAppearance.palette(card.style);
    final issuer = card.issuer;
    return CardCanvas(
      shadow: CardAppearance.shadow(palette),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.printWhite,
          border: Border.all(color: AppColors.printBorder),
        ),
        child: Stack(
          children: [
            Positioned(
              left: _margin,
              top: _margin,
              right: _margin,
              height: _bandHeight,
              child: _PictureBand(card: card, palette: palette),
            ),
            Positioned(
              left: _margin + AppSpacing.sm,
              top: _margin + AppSpacing.sm,
              child: _NumberBox(number: card.number),
            ),
            if (issuer.contactPhone != null)
              Positioned(
                right: _margin + AppSpacing.sm,
                top: _margin + AppSpacing.xl,
                child: _InfoOval(issuer: issuer),
              ),
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.md,
              child: _WrittenLines(card: card, ink: palette.ink),
            ),
          ],
        ),
      ),
    );
  }
}

/// The photo-like band: the palette as sky-to-water gradient, the category
/// pattern at full strength, and the wordmark.
class _PictureBand extends StatelessWidget {
  const _PictureBand({required this.card, required this.palette});

  final DigitalCard card;
  final CardPalette palette;

  static const double _patternStrength = 2.4;

  /// Room kept free on the right for the "Info" bubble.
  static const double _infoClearance = 96;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.sm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: palette.gradient,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: CardPatternPainter(
                  card.issuer.category,
                  strength: _patternStrength,
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: _infoClearance,
              bottom: AppSpacing.sm,
              child: _Wordmark(issuer: card.issuer),
            ),
          ],
        ),
      ),
    );
  }
}

/// Name and emblem in large translucent letters, tagline spaced out below,
/// as printed over the picture.
class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.issuer});

  final Issuer issuer;

  static const double _nameSize = 40;
  static const double _taglineTracking = 3;

  @override
  Widget build(BuildContext context) {
    final tagline = issuer.tagline;
    final ink = AppColors.onDark.withValues(alpha: 0.82);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                issuer.name,
                style: TextStyle(
                  color: ink,
                  fontSize: _nameSize,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                CardAppearance.emblemIcon(issuer),
                color: ink,
                size: _nameSize * 0.8,
              ),
            ],
          ),
          if (tagline != null)
            Text(
              tagline,
              style: TextStyle(
                color: ink,
                fontSize: AppFontSize.small,
                letterSpacing: _taglineTracking,
              ),
            ),
        ],
      ),
    );
  }
}

/// The white rounded box in the corner of the band. Printed empty on paper
/// cards and filled in by staff; empty here too when there is no number.
class _NumberBox extends StatelessWidget {
  const _NumberBox({required this.number});

  final String? number;

  static const double _width = 92;
  static const double _height = 46;
  static const double _labelTracking = 0.6;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.printWhite.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context).cardNumberLabel,
              maxLines: 1,
              style: AppTypography.printSerif.copyWith(
                color: AppColors.paperInk,
                fontSize: AppFontSize.caption,
                fontWeight: FontWeight.w700,
                letterSpacing: _labelTracking,
              ),
            ),
          ),
          const Spacer(),
          Text(
            number ?? '',
            style: const TextStyle(
              color: AppColors.penInk,
              fontSize: AppFontSize.bodyLarge,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// The white oval with contact details on the right of the band.
class _InfoOval extends StatelessWidget {
  const _InfoOval({required this.issuer});

  final Issuer issuer;

  static const double _width = 90;
  static const double _height = 64;

  @override
  Widget build(BuildContext context) {
    final contactName = issuer.contactName;
    final style = AppTypography.printSerif.copyWith(
      color: AppColors.paperInk,
      fontSize: AppFontSize.small,
      height: 1.2,
    );
    return Container(
      width: _width,
      height: _height,
      decoration: const BoxDecoration(
        color: AppColors.printWhite,
        borderRadius: BorderRadius.all(
          Radius.elliptical(_width / 2, _height / 2),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context).cardInfoLabel,
              style: style.copyWith(fontStyle: FontStyle.italic),
            ),
            Text(
              issuer.contactPhone!,
              style: style.copyWith(fontWeight: FontWeight.w700),
            ),
            if (contactName != null) Text(contactName, style: style),
          ],
        ),
      ),
    );
  }
}

/// COGNOME / NOME with the holder written in pen on a lane-rope line, or the
/// reward for an anonymous loyalty card.
class _WrittenLines extends StatelessWidget {
  const _WrittenLines({required this.card, required this.ink});

  final DigitalCard card;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final holder = card.holder;
    final reward = card.reward;
    final lines = <(String, String)>[
      if (holder != null) ...[
        (l10n.cardSurnameLabel, holder.lastName),
        (l10n.cardNameLabel, holder.firstName),
      ] else if (reward != null)
        (l10n.cardRewardLabel, reward),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (label, value) in lines) ...[
          _WrittenLine(label: label, value: value, ink: ink),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _WrittenLine extends StatelessWidget {
  const _WrittenLine({
    required this.label,
    required this.value,
    required this.ink,
  });

  final String label;
  final String value;
  final Color ink;

  static const double _labelWidth = 84;
  static const double _ropeHeight = 3;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: _labelWidth,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.bottomLeft,
            child: Text(
              label,
              maxLines: 1,
              style: AppTypography.printSerif.copyWith(
                color: AppColors.paperInk,
                fontSize: AppFontSize.body,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.xs),
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.penInk,
                    fontSize: AppFontSize.title,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ),
              LaneRope(
                color: ink,
                alternate: AppColors.printBorder,
                height: _ropeHeight,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
