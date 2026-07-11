import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../generated/app_colors.dart';
import '../../generated/app_spacing.dart';
import '../../generated/app_typography.dart';

/// A tappable card for an activity (walking, breathing exercises, and
/// similar): a leading icon, a title with a range/paw-count subtitle, and a
/// trailing chevron.
///
/// [icon] is a parameter rather than baked in so the same component serves
/// every activity type.
class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.range,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String range;
  final VoidCallback? onTap;

  static const double _cardPadding = 16;
  static const double _cardRadius = 20;
  static const double _borderWidth = 1;
  static const double _contentGap = 12;
  static const double _leadingIconSize = 32;
  static const double _pawIconSize = 14;
  static const double _chevronSize = 20;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(_cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(_cardRadius),
          border: Border.all(color: AppColors.border, width: _borderWidth),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: _leadingIconSize, color: AppColors.primary),
            const SizedBox(width: _contentGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        range,
                        style: AppTypography.label.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(
                        LucideIcons.pawPrint,
                        size: _pawIconSize,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: _contentGap),
            const Icon(
              LucideIcons.chevronRight,
              size: _chevronSize,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
