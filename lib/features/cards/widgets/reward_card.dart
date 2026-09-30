import 'package:flutter/material.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/widgets/card_appearance.dart';
import 'package:punchy/l10n/app_localizations.dart';
import 'package:punchy/shared/theme/app_colors.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';

/// The reward of a loyalty card, with how far the user is from it. Turns
/// into a celebratory banner once the card is full.
class RewardCard extends StatelessWidget {
  const RewardCard({super.key, required this.card});

  final DigitalCard card;

  static const double _iconBox = 48;

  @override
  Widget build(BuildContext context) {
    final palette = CardAppearance.palette(card.style);
    final ready = card.isRewardReady;

    return AnimatedContainer(
      duration: AppDurations.medium,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: ready
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: palette.gradient,
              )
            : null,
        color: ready ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: ready ? null : Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Container(
            width: _iconBox,
            height: _iconBox,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ready
                  ? AppColors.glass
                  : palette.ink.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.redeem_rounded,
              color: ready ? AppColors.onDark : palette.ink,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _RewardText(card: card, palette: palette),
          ),
        ],
      ),
    );
  }
}

class _RewardText extends StatelessWidget {
  const _RewardText({required this.card, required this.palette});

  final DigitalCard card;
  final CardPalette palette;

  static const double _barHeight = 8;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ready = card.isRewardReady;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.cardDetailRewardTitle,
          style: TextStyle(
            fontSize: AppFontSize.small,
            color: ready ? AppColors.onDarkMuted : AppColors.textSecondary,
          ),
        ),
        Text(
          card.reward ?? '',
          style: TextStyle(
            fontSize: AppFontSize.title,
            fontWeight: FontWeight.w800,
            color: ready ? AppColors.onDark : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (ready)
          Text(
            l10n.cardDetailRewardReady,
            style: const TextStyle(
              fontSize: AppFontSize.body,
              fontWeight: FontWeight.w600,
              color: AppColors.onDark,
            ),
          )
        else ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: LinearProgressIndicator(
              value: card.usedSlots / card.totalSlots,
              minHeight: _barHeight,
              color: palette.ink,
              backgroundColor: palette.ink.withValues(alpha: 0.15),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.cardDetailRewardProgress(card.remainingSlots),
            style: const TextStyle(
              fontSize: AppFontSize.small,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
