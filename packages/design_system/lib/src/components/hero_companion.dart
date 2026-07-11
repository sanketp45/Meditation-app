import 'package:flutter/material.dart';

import '../../generated/app_colors.dart';
import '../../generated/app_spacing.dart';

/// Which companion illustration [HeroCompanion] renders.
enum CompanionState {
  /// No activity logged yet today — pairs with the zero-count stats state.
  sleeping,

  /// At least one activity has been logged today.
  active,
}

/// The home screen's hero section: a companion illustration centered over a
/// soft sunrise-style glow, sized proportionally to the available width.
///
/// 24px of vertical space (the 4px-grid `AppSpacing.lg`) is reserved above
/// and below the section so it sits correctly between the top bar and
/// whatever comes next.
class HeroCompanion extends StatelessWidget {
  const HeroCompanion({super.key, required this.state});

  final CompanionState state;

  static const double _illustrationWidthFactor = 0.62; // 60-65% of content width
  static const double _glowWidthFactor = 0.92;
  static const double _glowAspectRatio = 1.35; // glow width / glow height

  String get _assetName => switch (state) {
        CompanionState.sleeping => 'assets/companion/cat_sleeping.png',
        CompanionState.active => 'assets/companion/cat_active.png',
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final glowWidth = constraints.maxWidth * _glowWidthFactor;
          final glowHeight = glowWidth / _glowAspectRatio;
          final illustrationWidth =
              constraints.maxWidth * _illustrationWidthFactor;

          return SizedBox(
            height: glowHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: glowWidth,
                  height: glowHeight,
                  child: const _SunriseGlow(),
                ),
                SizedBox(
                  width: illustrationWidth,
                  child: Image.asset(
                    _assetName,
                    package: 'design_system',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A layered radial glow behind the companion, evoking a sunrise silhouette
/// using the peach (`sessionBackground`) and cream (`background`) tokens.
class _SunriseGlow extends StatelessWidget {
  const _SunriseGlow();

  static const List<(double sizeFactor, double alpha)> _rings = [
    (1.00, 0.28),
    (0.72, 0.45),
    (0.46, 0.70),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        for (final (sizeFactor, alpha) in _rings)
          FractionallySizedBox(
            widthFactor: sizeFactor,
            heightFactor: sizeFactor,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.sessionBackground.withValues(alpha: alpha),
                    AppColors.background.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
