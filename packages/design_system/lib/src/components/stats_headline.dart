import 'package:flutter/material.dart';

import '../../generated/app_colors.dart';
import '../../generated/app_spacing.dart';
import '../../generated/app_typography.dart';

/// The home screen's stats headline: a centered "N paws today" line with a
/// centered subtext line beneath it.
///
/// Standalone and independent of [HeroCompanion] and the top bar's paw
/// count pill — none of them render from a shared widget, they're only
/// expected to agree at the data level (same underlying paw count).
class StatsHeadline extends StatelessWidget {
  const StatsHeadline({
    super.key,
    required this.pawCount,
    required this.subtext,
  });

  final int pawCount;
  final String subtext;

  String get _headline =>
      '$pawCount ${pawCount == 1 ? 'paw' : 'paws'} today';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _headline,
            textAlign: TextAlign.center,
            style: AppTypography.title.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtext,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
