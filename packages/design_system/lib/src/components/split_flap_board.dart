import 'package:flutter/material.dart';

import '../../generated/app_colors.dart';
import '../../generated/app_radius.dart';
import 'split_flap/split_flap_layout.dart';
import 'split_flap/split_flap_tile.dart';

/// A mechanical split-flap ("Solari board") text display: scrambles through
/// random characters before settling on [text], one tile per character on a
/// 12-column by 4-row grid.
///
/// [text] is word-wrapped to the 12-column width (explicit `\n` line breaks
/// are honored) and centered both horizontally and vertically within the
/// 4-row grid. Text longer than the grid can hold is truncated to the first
/// four wrapped lines, since the board is a fixed physical size.
///
/// All animation timings (the flip itself, the scramble cadence, and the
/// column/row stagger) scale proportionally with [duration], which defaults
/// to the reference ~0.35s single-flip duration.
class SplitFlapBoard extends StatelessWidget {
  const SplitFlapBoard({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 350),
    this.autoPlay = true,
  });

  final String text;

  /// Base duration of a single tile flip. Scramble step interval and the
  /// column/row stagger delays scale proportionally to this value.
  final Duration duration;

  /// When false, tiles render directly at their settled target character
  /// with no scramble/flip animation — useful for a "settled" preview or a
  /// reduced-motion presentation.
  final bool autoPlay;

  static const int columns = 12;
  static const int rows = 4;
  static const double _tileAspectRatio = 1 / 2; // width : height
  static const double _tileGap = 2;
  static const double _boardPadding = 12;
  static const double _tileRadius = 3;
  static const double _referenceFlipMs = 350;
  static const double _referenceScrambleIntervalMs = 55;
  static const double _referenceColumnStaggerMs = 30;
  static const double _referenceRowStaggerMs = 20;

  @override
  Widget build(BuildContext context) {
    final grid = buildSplitFlapGrid(text, columns: columns, rows: rows);
    final scale = duration.inMilliseconds / _referenceFlipMs;
    final scrambleInterval = Duration(
      milliseconds: (_referenceScrambleIntervalMs * scale).round(),
    );
    final columnStagger = Duration(
      milliseconds: (_referenceColumnStaggerMs * scale).round(),
    );
    final rowStagger = Duration(
      milliseconds: (_referenceRowStaggerMs * scale).round(),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final tileWidth =
            (availableWidth - _boardPadding * 2 - _tileGap * (columns - 1)) /
                columns;
        final tileHeight = tileWidth / _tileAspectRatio;
        final textStyle = TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: tileHeight * 0.42,
          color: AppColors.textInverse,
          height: 1,
        );

        return Container(
          width: availableWidth,
          padding: const EdgeInsets.all(_boardPadding),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var row = 0; row < rows; row++) ...[
                if (row > 0) const SizedBox(height: _tileGap),
                Row(
                  children: [
                    for (var col = 0; col < columns; col++) ...[
                      if (col > 0) const SizedBox(width: _tileGap),
                      SplitFlapTile(
                        key: ValueKey('$row-$col'),
                        targetChar: grid[row][col],
                        width: tileWidth,
                        height: tileHeight,
                        flipDuration: duration,
                        scrambleInterval: scrambleInterval,
                        startDelay: columnStagger * col + rowStagger * row,
                        textStyle: textStyle,
                        tileColor: AppColors.textPrimary,
                        splitLineColor: Colors.black.withValues(alpha: 0.4),
                        tileRadius: _tileRadius,
                        autoPlay: autoPlay,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
