import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/repository/cards_repository.dart';
import 'package:punchy/features/cards/view_model/card_detail_view_model.dart';
import 'package:punchy/features/cards/widgets/card_appearance.dart';
import 'package:punchy/features/cards/widgets/card_history.dart';
import 'package:punchy/features/cards/widgets/reward_card.dart';
import 'package:punchy/features/cards/widgets/card_back.dart';
import 'package:punchy/features/cards/widgets/card_front.dart';
import 'package:punchy/l10n/app_localizations.dart';
import 'package:punchy/shared/theme/app_colors.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';
import 'package:punchy/shared/ui/formatters.dart';
import 'package:punchy/shared/ui/ui_state.dart';
import 'package:punchy/shared/widgets/flip_card.dart';
import 'package:punchy/shared/widgets/message_view.dart';

class CardDetailScreen extends StatelessWidget {
  const CardDetailScreen({super.key, required this.cardId});

  final String cardId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          CardDetailViewModel(context.read<CardsRepository>(), cardId)..load(),
      child: const _CardDetailView(),
    );
  }
}

class _CardDetailView extends StatelessWidget {
  const _CardDetailView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.select<CardDetailViewModel, UiState<DigitalCard>>(
      (vm) => vm.state,
    );
    return Scaffold(
      appBar: AppBar(
        title: switch (state) {
          UiSuccess(data: final card) => Text(
            card.issuer.name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          _ => null,
        },
      ),
      body: switch (state) {
        UiLoading() => const Center(child: CircularProgressIndicator()),
        UiError() => MessageView(
          icon: Icons.credit_card_off_rounded,
          message: l10n.cardDetailError,
          actionLabel: l10n.cardsRetry,
          onAction: context.read<CardDetailViewModel>().load,
        ),
        UiSuccess(data: final card) => _CardDetailBody(card: card),
      },
    );
  }
}

class _CardDetailBody extends StatelessWidget {
  const _CardDetailBody({required this.card});

  final DigitalCard card;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<CardDetailViewModel>();
    final showBack = context.select<CardDetailViewModel, bool>(
      (vm) => vm.showBack,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxxl,
      ),
      children: [
        Hero(
          tag: CardAppearance.heroTag(card.id),
          child: FlipCard(
            showBack: showBack,
            onFlipRequested: viewModel.flip,
            front: CardFront(card: card),
            back: CardBack(card: card),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.touch_app_outlined,
              size: AppFontSize.bodyLarge,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                l10n.cardDetailFlipHint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppFontSize.small,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: false,
                label: Text(l10n.cardDetailFront),
                icon: const Icon(Icons.badge_outlined),
              ),
              ButtonSegment(
                value: true,
                label: Text(l10n.cardDetailBack),
                icon: const Icon(Icons.grid_view_rounded),
              ),
            ],
            selected: {showBack},
            onSelectionChanged: (s) => viewModel.setShowBack(s.first),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _Stats(card: card),
        if (card.program == CardProgram.loyalty && card.reward != null) ...[
          const SizedBox(height: AppSpacing.lg),
          RewardCard(card: card),
        ],
        const SizedBox(height: AppSpacing.xl),
        CardHistory(card: card),
      ],
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.card});

  final DigitalCard card;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final validUntil = card.validUntil;
    // Every tile takes the height of the tallest, so a label that wraps in
    // one language never leaves the row uneven.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatTile(
            icon: switch (card.program) {
              CardProgram.entries => Icons.login_rounded,
              CardProgram.monthly => Icons.event_available_rounded,
              CardProgram.loyalty => Icons.approval_rounded,
            },
            label: switch (card.program) {
              CardProgram.entries => l10n.cardDetailEntriesUsed,
              CardProgram.monthly => l10n.cardDetailMonthsPaid,
              CardProgram.loyalty => l10n.cardDetailStampsCollected,
            },
            value: '${card.usedSlots}/${card.totalSlots}',
          ),
          const SizedBox(width: AppSpacing.md),
          _StatTile(
            icon: Icons.hourglass_bottom_rounded,
            label: card.program == CardProgram.loyalty
                ? l10n.cardDetailToReward
                : l10n.cardDetailRemaining,
            value: '${card.remainingSlots}',
          ),
          const SizedBox(width: AppSpacing.md),
          _StatTile(
            icon: Icons.event_rounded,
            label: l10n.cardDetailValidUntil,
            value: validUntil == null
                ? l10n.cardDetailNoExpiry
                : Formatters.shortDate(validUntil, locale),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: AppFontSize.title, color: AppColors.primary),
            const SizedBox(height: AppSpacing.sm),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                // One line, also when the row measures intrinsic heights:
                // the FittedBox shrinks it instead.
                maxLines: 1,
                softWrap: false,
                style: const TextStyle(
                  fontSize: AppFontSize.title,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              label,
              maxLines: 2,
              style: const TextStyle(
                fontSize: AppFontSize.caption,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
