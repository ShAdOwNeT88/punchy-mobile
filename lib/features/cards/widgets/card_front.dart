import 'package:flutter/material.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/widgets/card_appearance.dart';
import 'package:punchy/features/cards/widgets/card_decorations.dart';
import 'package:punchy/features/cards/widgets/paper_card_front.dart';
import 'package:punchy/l10n/app_localizations.dart';
import 'package:punchy/shared/theme/app_colors.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';

/// Front face: issuer, card number, contact, and holder or reward — the same
/// information as the paper card, in the design the issuer picked.
class CardFront extends StatelessWidget {
  const CardFront({super.key, required this.card});

  final DigitalCard card;

  @override
  Widget build(BuildContext context) => switch (card.design) {
    CardDesign.gradient => _GradientFront(card: card),
    CardDesign.paper => PaperCardFront(card: card),
  };
}

class _GradientFront extends StatelessWidget {
  const _GradientFront({required this.card});

  final DigitalCard card;

  @override
  Widget build(BuildContext context) {
    final palette = CardAppearance.palette(card.style);
    final number = card.number;
    final holder = card.holder;
    final reward = card.reward;
    return CardCanvas(
      shadow: CardAppearance.shadow(palette),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: palette.gradient,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: CardPatternPainter(card.issuer.category),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopRow(card: card),
                  const Spacer(),
                  if (number != null) ...[
                    _NumberPill(number: number),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  if (holder != null)
                    _HolderPanel(holder: holder, accent: palette.ink)
                  else if (reward != null)
                    _RewardPanel(reward: reward, accent: palette.ink),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({required this.card});

  final DigitalCard card;

  static const double _logoSize = 40;

  @override
  Widget build(BuildContext context) {
    final issuer = card.issuer;
    final tagline = issuer.tagline;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: _logoSize,
          height: _logoSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.glass,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Icon(
            CardAppearance.emblemIcon(issuer),
            color: AppColors.onDark,
            size: AppFontSize.headline,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                issuer.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.onDark,
                  fontSize: AppFontSize.headline,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              if (tagline != null)
                Text(
                  tagline.split('').join(' '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.onDarkMuted,
                    fontSize: AppFontSize.caption,
                    letterSpacing: 1.2,
                  ),
                ),
            ],
          ),
        ),
        if (issuer.contactPhone != null) _InfoBubble(issuer: issuer),
      ],
    );
  }
}

class _InfoBubble extends StatelessWidget {
  const _InfoBubble({required this.issuer});

  final Issuer issuer;

  @override
  Widget build(BuildContext context) {
    final contactName = issuer.contactName;
    const textStyle = TextStyle(
      color: AppColors.onDark,
      fontSize: AppFontSize.caption,
      height: 1.25,
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).cardInfoLabel,
            style: textStyle.copyWith(fontStyle: FontStyle.italic),
          ),
          Text(
            issuer.contactPhone!,
            style: textStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          if (contactName != null) Text(contactName, style: textStyle),
        ],
      ),
    );
  }
}

class _NumberPill extends StatelessWidget {
  const _NumberPill({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${AppLocalizations.of(context).cardNumberLabel}  ',
              style: const TextStyle(
                fontSize: AppFontSize.micro,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: number,
              style: const TextStyle(
                fontSize: AppFontSize.body,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        style: const TextStyle(color: AppColors.onDark),
      ),
    );
  }
}

/// The white strip with surname and name, underlined by a lane-rope
/// dashed line as on the paper card.
class _HolderPanel extends StatelessWidget {
  const _HolderPanel({required this.holder, required this.accent});

  final CardHolder holder;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.paper.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Column(
        children: [
          _HolderLine(
            label: l10n.cardSurnameLabel,
            value: holder.lastName,
            accent: accent,
          ),
          const SizedBox(height: AppSpacing.xs),
          _HolderLine(
            label: l10n.cardNameLabel,
            value: holder.firstName,
            accent: accent,
          ),
        ],
      ),
    );
  }
}

/// For anonymous loyalty cards: what a full card earns, where the holder
/// would otherwise be.
class _RewardPanel extends StatelessWidget {
  const _RewardPanel({required this.reward, required this.accent});

  final String reward;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.paper.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: [
          Icon(Icons.redeem_rounded, color: accent, size: AppFontSize.headline),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).cardRewardLabel,
                  style: const TextStyle(
                    color: AppColors.paperInk,
                    fontSize: AppFontSize.caption,
                    letterSpacing: _HolderLine._labelTracking,
                  ),
                ),
                Text(
                  reward,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: accent,
                    fontSize: AppFontSize.bodyLarge,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HolderLine extends StatelessWidget {
  const _HolderLine({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  static const double _labelWidth = 72;
  static const double _labelTracking = 0.8;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: _labelWidth,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.paperInk,
              fontSize: AppFontSize.caption,
              letterSpacing: _labelTracking,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: accent,
                  fontSize: AppFontSize.bodyLarge,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
              LaneRope(color: accent),
            ],
          ),
        ),
      ],
    );
  }
}
