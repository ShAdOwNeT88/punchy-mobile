import 'package:flutter/material.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/widgets/card_appearance.dart';
import 'package:punchy/l10n/app_localizations.dart';
import 'package:punchy/shared/theme/app_colors.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';
import 'package:punchy/shared/ui/formatters.dart';

/// The stamps of a card as a list, newest first.
class CardHistory extends StatelessWidget {
  const CardHistory({super.key, required this.card});

  final DigitalCard card;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stamps = card.stamps.reversed.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.cardDetailHistory,
          style: const TextStyle(
            fontSize: AppFontSize.title,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (stamps.isEmpty)
          Text(
            l10n.cardDetailHistoryEmpty,
            style: const TextStyle(color: AppColors.textSecondary),
          )
        else
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadii.lg),
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              children: [
                for (var i = 0; i < stamps.length; i++) ...[
                  if (i > 0)
                    const Divider(
                      height: 1,
                      indent: AppSpacing.lg,
                      endIndent: AppSpacing.lg,
                    ),
                  _HistoryTile(card: card, stamp: stamps[i]),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.card, required this.stamp});

  final DigitalCard card;
  final CardStamp stamp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final ink = CardAppearance.palette(card.style).ink;
    final date = Formatters.shortDate(stamp.date, locale);
    final initials = stamp.operatorInitials;
    final amount = stamp.amountCents;

    final title = switch (card.program) {
      CardProgram.entries => l10n.cardDetailStampEntry,
      CardProgram.monthly => l10n.cardDetailStampMonth(
        Formatters.monthYear(stamp.period ?? stamp.date, locale),
      ),
      CardProgram.loyalty => l10n.cardDetailStampLoyalty,
    };

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: ink.withValues(alpha: 0.12),
        foregroundColor: ink,
        child: Icon(switch (card.program) {
          CardProgram.entries => Icons.check_rounded,
          CardProgram.monthly => Icons.payments_outlined,
          CardProgram.loyalty => Icons.approval_rounded,
        }),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        initials == null
            ? l10n.cardDetailStampDate(date)
            : l10n.cardDetailStampOperator(date, initials),
      ),
      trailing: amount == null
          ? null
          : Text(
              Formatters.euroCents(amount, locale),
              style: const TextStyle(
                fontSize: AppFontSize.body,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
