import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../generated/app_colors.dart';
import '../../generated/app_spacing.dart';
import '../../generated/app_typography.dart';

/// A promo-style teaser card (title, subtitle, decorative icon, trailing
/// chevron on a brand-gradient fill) that links out to a fuller experience
/// elsewhere — e.g. the quote-of-the-day flip board on its own screen.
class QuoteTeaserCard extends StatelessWidget {
  const QuoteTeaserCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  static const double _radius = 20;
  static const double _padding = 16;
  static const double _decorativeIconSize = 96;
  static const double _chevronSize = 20;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.companion],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(_padding),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -12,
                  bottom: -16,
                  child: Icon(
                    LucideIcons.quote,
                    size: _decorativeIconSize,
                    color: AppColors.textInverse.withValues(alpha: 0.16),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.textInverse,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textInverse.withValues(
                                alpha: 0.85,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(
                      LucideIcons.chevronRight,
                      size: _chevronSize,
                      color: AppColors.textInverse,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
