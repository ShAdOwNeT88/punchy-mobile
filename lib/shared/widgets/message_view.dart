import 'package:flutter/material.dart';
import 'package:punchy/shared/theme/app_colors.dart';
import 'package:punchy/shared/theme/app_dimensions.dart';

/// A centred icon, message and optional action: used for empty and error
/// states. The caller supplies already-localized text.
class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  static const double _iconSize = 56;

  @override
  Widget build(BuildContext context) {
    final label = actionLabel;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: _iconSize, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppFontSize.bodyLarge,
                color: AppColors.textSecondary,
              ),
            ),
            if (label != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton(onPressed: onAction, child: Text(label)),
            ],
          ],
        ),
      ),
    );
  }
}
