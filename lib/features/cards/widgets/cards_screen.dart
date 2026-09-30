import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:punchy/core/navigation/routes.dart';
import 'package:punchy/core/session/session_controller.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/features/cards/repository/cards_repository.dart';
import 'package:punchy/features/cards/view_model/cards_view_model.dart';
import 'package:punchy/features/cards/widgets/card_appearance.dart';
import 'package:punchy/features/cards/widgets/card_front.dart';
import 'package:punchy/l10n/app_localizations.dart';
import 'package:punchy/shared/theme/app_colors.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';
import 'package:punchy/shared/ui/ui_state.dart';
import 'package:punchy/shared/widgets/message_view.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardsViewModel(
        context.read<CardsRepository>(),
        context.read<SessionController>(),
      )..load(),
      child: const _CardsView(),
    );
  }
}

class _CardsView extends StatelessWidget {
  const _CardsView();

  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    await context.read<CardsViewModel>().logout();
    navigator.pushNamedAndRemoveUntil(Routes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: context.read<CardsViewModel>().refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar.large(
              backgroundColor: AppColors.background,
              title: Text(
                l10n.cardsTitle,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              actions: [
                IconButton(
                  tooltip: l10n.cardsLogout,
                  icon: const Icon(Icons.logout_rounded),
                  onPressed: () => _logout(context),
                ),
              ],
            ),
            const SliverToBoxAdapter(child: _Greeting()),
            const SliverToBoxAdapter(child: _FilterChips()),
            const _CardsContent(),
          ],
        ),
      ),
    );
  }
}

/// The sliver below the header: loading, error, empty or the list.
class _CardsContent extends StatelessWidget {
  const _CardsContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.select<CardsViewModel, UiState<List<DigitalCard>>>(
      (vm) => vm.state,
    );
    return switch (state) {
      UiLoading() => const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      UiError() => SliverFillRemaining(
        hasScrollBody: false,
        child: MessageView(
          icon: Icons.cloud_off_rounded,
          message: l10n.cardsError,
          actionLabel: l10n.cardsRetry,
          onAction: context.read<CardsViewModel>().retry,
        ),
      ),
      UiSuccess(data: final cards) when cards.isEmpty => SliverFillRemaining(
        hasScrollBody: false,
        child: MessageView(
          icon: Icons.style_outlined,
          message: context.read<CardsViewModel>().filter == CardFilter.all
              ? l10n.cardsEmpty
              : l10n.cardsFilterEmpty,
        ),
      ),
      UiSuccess(data: final cards) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        sliver: SliverList.separated(
          itemCount: cards.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xl),
          itemBuilder: (context, i) => _CardTile(card: cards[i], index: i),
        ),
      ),
    };
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = context.select<CardsViewModel, String?>((vm) => vm.firstName);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Text(
        name == null ? l10n.cardsGreetingAnonymous : l10n.cardsGreeting(name),
        style: const TextStyle(
          fontSize: AppFontSize.bodyLarge,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({required this.card, required this.index});

  final DigitalCard card;
  final int index;

  static const _entranceStagger = Duration(milliseconds: 90);
  static const double _entranceOffset = 40;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppDurations.medium + _entranceStagger * index,
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * _entranceOffset),
          child: child,
        ),
      ),
      child: GestureDetector(
        onTap: () =>
            Navigator.of(context)
                .pushNamed(Routes.cardDetail, arguments: card.id),
        child: Column(
          children: [
            Hero(
              tag: CardAppearance.heroTag(card.id),
              child: CardFront(card: card),
            ),
            const SizedBox(height: AppSpacing.md),
            _UsageBar(card: card),
          ],
        ),
      ),
    );
  }
}

class _UsageBar extends StatelessWidget {
  const _UsageBar({required this.card});

  final DigitalCard card;

  static const double _barHeight = 6;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ink = CardAppearance.palette(card.style).ink;
    final label = switch (card.program) {
      CardProgram.entries => l10n.cardsProgressEntries(
        card.usedSlots,
        card.totalSlots,
      ),
      CardProgram.monthly => l10n.cardsProgressMonths(
        card.usedSlots,
        card.totalSlots,
      ),
      CardProgram.loyalty => l10n.cardsProgressLoyalty(
        card.usedSlots,
        card.totalSlots,
      ),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.pill),
              child: LinearProgressIndicator(
                value: card.usedSlots / card.totalSlots,
                minHeight: _barHeight,
                color: ink,
                backgroundColor: ink.withValues(alpha: 0.15),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          if (card.isRewardReady)
            _RewardBadge(label: l10n.cardsRewardReady, ink: ink)
          else
            Text(
              label,
              style: const TextStyle(
                fontSize: AppFontSize.small,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _RewardBadge extends StatelessWidget {
  const _RewardBadge({required this.label, required this.ink});

  final String label;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: ink.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.redeem_rounded, color: ink, size: AppFontSize.body),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              color: ink,
              fontSize: AppFontSize.small,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tutte / Abbonamenti / Fedeltà — shown only when the user holds both kinds.
class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.read<CardsViewModel>();
    final canFilter = context.select<CardsViewModel, bool>(
      (vm) => vm.canFilter,
    );
    final selected = context.select<CardsViewModel, CardFilter>(
      (vm) => vm.filter,
    );
    if (!canFilter) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          for (final filter in CardFilter.values) ...[
            ChoiceChip(
              label: Text(switch (filter) {
                CardFilter.all => l10n.cardsFilterAll,
                CardFilter.memberships => l10n.cardsFilterMemberships,
                CardFilter.loyalty => l10n.cardsFilterLoyalty,
              }),
              selected: filter == selected,
              showCheckmark: false,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: filter == selected
                    ? AppColors.onDark
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              onSelected: (_) => viewModel.setFilter(filter),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
