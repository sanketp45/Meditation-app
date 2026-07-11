import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../generated/app_colors.dart';
import '../../generated/app_radius.dart';
import '../../generated/app_spacing.dart';
import '../../generated/app_typography.dart';

/// A 2-column-grid activity card: icon, title, paw-count range, and a
/// single full-width "Start" button — no secondary "read more" link.
///
/// On tap, the card tilts in 3D toward the touch point and scales down
/// slightly before settling back to flat, a touch-native stand-in for a
/// mouse-hover perspective-tilt effect (there's no persistent "hover" state
/// to drive on a touchscreen, so the tilt is driven by the tap gesture
/// instead).
class GridActivityCard extends StatefulWidget {
  const GridActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.range,
    this.onStart,
  });

  final IconData icon;
  final String title;
  final String range;
  final VoidCallback? onStart;

  @override
  State<GridActivityCard> createState() => _GridActivityCardState();
}

class _GridActivityCardState extends State<GridActivityCard>
    with SingleTickerProviderStateMixin {
  static const double _pressScale = 0.96;
  static const double _maxTiltRadians = 0.06; // ~3.4 degrees, subtle

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );
  Alignment _tapAlignment = Alignment.center;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details, Size size) {
    final dx = size.width == 0 ? 0.0 : (details.localPosition.dx / size.width) * 2 - 1;
    final dy = size.height == 0 ? 0.0 : (details.localPosition.dy / size.height) * 2 - 1;
    setState(() {
      _tapAlignment = Alignment(dx.clamp(-1.0, 1.0), dy.clamp(-1.0, 1.0));
    });
    _controller.forward();
  }

  void _handleTapEnd() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          onTapDown: (details) => _handleTapDown(details, size),
          onTapUp: (_) => _handleTapEnd(),
          onTapCancel: _handleTapEnd,
          onTap: widget.onStart,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = _controller.value;
              final tiltX = -_tapAlignment.y * _maxTiltRadians * t;
              final tiltY = _tapAlignment.x * _maxTiltRadians * t;
              final scale = 1 - (1 - _pressScale) * t;
              final matrix = Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..rotateX(tiltX)
                ..rotateY(tiltY)
                ..scaleByDouble(scale, scale, scale, 1);
              return Transform(
                alignment: Alignment.center,
                transform: matrix,
                child: child,
              );
            },
            child: _CardContent(
              icon: widget.icon,
              title: widget.title,
              range: widget.range,
            ),
          ),
        );
      },
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.icon,
    required this.title,
    required this.range,
  });

  final IconData icon;
  final String title;
  final String range;

  static const double _cardPadding = 16;
  static const double _cardRadius = 20;
  static const double _borderWidth = 1;
  static const double _iconSize = 28;
  static const double _pawIconSize = 14;
  static const double _ctaHeight = 36;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: AppColors.border, width: _borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _iconSize, color: AppColors.primary),
          const SizedBox(height: AppSpacing.sm),
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
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: _ctaHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Center(
                child: Text(
                  'Start',
                  style: AppTypography.labelStrong.copyWith(
                    color: AppColors.textInverse,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
