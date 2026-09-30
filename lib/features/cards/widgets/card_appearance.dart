import 'package:flutter/material.dart';
import 'package:punchy/features/cards/models/digital_card.dart';
import 'package:punchy/shared/theme/app_colors.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';

/// Maps card data onto theme tokens and icons, and holds the geometry shared
/// by both faces.
abstract final class CardAppearance {
  /// ISO/IEC 7810 ID-1, the size of a credit card.
  static const double aspectRatio = 85.60 / 53.98;

  /// Both faces are laid out at this width and scaled to fit, so the card
  /// looks identical in the list and in the detail.
  static const double designWidth = 340;
  static const double designHeight = designWidth / aspectRatio;

  /// Shared by the list and the detail, so the card flies between them.
  static String heroTag(String cardId) => 'card-$cardId';

  static CardPalette palette(CardStyle style) => switch (style) {
    CardStyle.ocean => CardPalette.ocean,
    CardStyle.ember => CardPalette.ember,
    CardStyle.violet => CardPalette.violet,
    CardStyle.forest => CardPalette.forest,
    CardStyle.coffee => CardPalette.coffee,
    CardStyle.rose => CardPalette.rose,
  };

  static IconData icon(IssuerCategory category) => switch (category) {
    IssuerCategory.pool => Icons.pool_rounded,
    IssuerCategory.gym => Icons.fitness_center_rounded,
    IssuerCategory.studio => Icons.self_improvement_rounded,
    IssuerCategory.cafe => Icons.local_cafe_rounded,
    IssuerCategory.restaurant => Icons.restaurant_rounded,
    IssuerCategory.shop => Icons.shopping_bag_rounded,
    IssuerCategory.beauty => Icons.content_cut_rounded,
    IssuerCategory.other => Icons.loyalty_rounded,
  };

  /// The issuer's logo symbol, or its category icon when it has none.
  static IconData emblemIcon(Issuer issuer) => switch (issuer.emblem) {
    IssuerEmblem.leaf => Icons.spa_rounded,
    IssuerEmblem.wave => Icons.waves_rounded,
    IssuerEmblem.star => Icons.star_rounded,
    IssuerEmblem.heart => Icons.favorite_rounded,
    IssuerEmblem.bolt => Icons.bolt_rounded,
    IssuerEmblem.crown => Icons.workspace_premium_rounded,
    null => icon(issuer.category),
  };

  static List<BoxShadow> shadow(CardPalette palette) => [
    BoxShadow(
      color: palette.gradient.first.withValues(alpha: 0.35),
      blurRadius: AppSpacing.xl,
      offset: const Offset(0, AppSpacing.md),
    ),
  ];
}

/// Lays [child] out at the design size and scales it to the available width.
class CardCanvas extends StatelessWidget {
  const CardCanvas({super.key, required this.child, this.shadow});

  final Widget child;
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: CardAppearance.aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          boxShadow: shadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
              width: CardAppearance.designWidth,
              height: CardAppearance.designHeight,
              child: Material(type: MaterialType.transparency, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
