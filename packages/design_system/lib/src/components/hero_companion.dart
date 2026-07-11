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

/// The home screen's hero section: a large, dominant companion illustration
/// over a soft sunrise-style glow that spans the full available width edge
/// to edge — there is no card, background fill, or border framing either
/// element; both render directly on whatever's behind this widget.
///
/// Callers should give this widget the full screen width (no horizontal
/// inset) so the glow is genuinely edge-to-edge, not just edge-to-edge
/// within some already-padded content column.
///
/// 24px of vertical space (the 4px-grid `AppSpacing.lg`) is reserved above
/// the section, between it and the top bar. No bottom padding is baked in —
/// callers own the gap between the hero and whatever comes next (e.g. the
/// stats headline sits close beneath it, only 4px away).
class HeroCompanion extends StatelessWidget {
  const HeroCompanion({super.key, required this.state});

  final CompanionState state;

  static const double _illustrationWidthFactor = 0.75; // 70-80% of screen width
  static const double _glowWidthFactor = 1.0; // edge to edge
  static const double _glowAspectRatio = 1.35; // glow width / glow height

  String get _assetName => switch (state) {
        CompanionState.sleeping => 'assets/companion/cat_sleeping.png',
        CompanionState.active => 'assets/companion/cat_active.png',
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
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
                  height: glowHeight,
                  child: Image.asset(
                    _assetName,
                    package: 'design_system',
                    fit: BoxFit.cover,
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
