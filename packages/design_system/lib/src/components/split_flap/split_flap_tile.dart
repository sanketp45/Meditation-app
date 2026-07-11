import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Characters a tile cycles through while scrambling: A-Z, 0-9, and a small
/// symbol set — deliberately excludes lowercase, matching a real split-flap
/// board's physical character set.
const String _scrambleCharPool = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%&*?';

/// Colors a tile may flash to instead of a character during a scramble step.
const List<Color> _flashColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.deepPurple,
  Colors.white,
];

/// What a tile face shows at a given moment: either a character or a solid
/// decorative flash color (never both).
class _TileFrame {
  const _TileFrame.character(this.char) : flashColor = null;
  const _TileFrame.flash(this.flashColor) : char = null;

  final String? char;
  final Color? flashColor;
}

/// A single split-flap tile: scrambles through random characters before
/// settling on [targetChar], using a two-flap 3D fold to transition between
/// each character shown along the way.
class SplitFlapTile extends StatefulWidget {
  const SplitFlapTile({
    super.key,
    required this.targetChar,
    required this.width,
    required this.height,
    required this.flipDuration,
    required this.scrambleInterval,
    required this.startDelay,
    required this.textStyle,
    required this.tileColor,
    required this.splitLineColor,
    required this.tileRadius,
    this.autoPlay = true,
  });

  final String targetChar;
  final double width;
  final double height;
  final Duration flipDuration;
  final Duration scrambleInterval;
  final Duration startDelay;
  final TextStyle textStyle;
  final Color tileColor;
  final Color splitLineColor;
  final double tileRadius;

  /// When false, the tile shows [targetChar] immediately with no scramble
  /// or flip animation.
  final bool autoPlay;

  @override
  State<SplitFlapTile> createState() => _SplitFlapTileState();
}

class _SplitFlapTileState extends State<SplitFlapTile>
    with SingleTickerProviderStateMixin {
  // The top flap folds away from flat (0°) to folded-back (-100°), hinged
  // at the tile's horizontal centerline (the bottom edge of the top half).
  static const double _topFlapAngleStart = 0;
  static const double _topFlapAngleEnd = -100;

  // The bottom flap unfolds from folded (90°, edge-on) down to flat (0°),
  // hinged at the same centerline (the top edge of the bottom half).
  static const double _bottomFlapAngleStart = 90;
  static const double _bottomFlapAngleEnd = 0;

  // The top flap plays out over the first ~2/3 of the timeline; the bottom
  // flap starts 50% into the top flap's own span and runs for the same
  // span again, so the two together fill the full [0, 1] controller range.
  static const double _topFlapSpan = 1 / 1.5;
  static const double _bottomFlapDelay = 0.5 * _topFlapSpan;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.flipDuration,
  );
  final math.Random _random = math.Random();

  _TileFrame _currentFrame = const _TileFrame.character(' ');
  _TileFrame _previousFrame = const _TileFrame.character(' ');
  int _flashCycle = 0;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      _runSequence();
    } else {
      _currentFrame = _TileFrame.character(widget.targetChar);
      _previousFrame = _currentFrame;
    }
  }

  @override
  void didUpdateWidget(covariant SplitFlapTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetChar == widget.targetChar) return;

    if (widget.autoPlay) {
      _runSequence();
    } else {
      setState(() {
        _previousFrame = _currentFrame;
        _currentFrame = _TileFrame.character(widget.targetChar);
      });
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    super.dispose();
  }

  Future<void> _runSequence() async {
    if (widget.startDelay > Duration.zero) {
      await Future.delayed(widget.startDelay);
      if (_disposed) return;
    }

    final isBlank = widget.targetChar == ' ';
    final steps = isBlank
        ? 6 + _random.nextInt(7) // 6-12
        : 20 + _random.nextInt(11); // 20-30

    for (var i = 0; i < steps; i++) {
      if (_disposed) return;
      _advanceTo(_TileFrame.character(_randomScrambleChar()), allowFlash: true);
      await Future.delayed(widget.scrambleInterval);
    }

    if (_disposed) return;
    _advanceTo(_TileFrame.character(widget.targetChar), allowFlash: false);
  }

  String _randomScrambleChar() =>
      _scrambleCharPool[_random.nextInt(_scrambleCharPool.length)];

  void _advanceTo(_TileFrame frame, {required bool allowFlash}) {
    _TileFrame nextFrame = frame;
    if (allowFlash && _random.nextDouble() < 0.20) {
      nextFrame = _TileFrame.flash(_flashColors[_flashCycle % _flashColors.length]);
      _flashCycle++;
    }

    if (!mounted) return;
    setState(() {
      _previousFrame = _currentFrame;
      _currentFrame = nextFrame;
    });
    _controller
      ..stop()
      ..value = 0
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final halfHeight = widget.height / 2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.tileRadius),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            // Static base: shows the current frame underneath the flaps.
            Column(
              children: [
                _TileFace(
                  frame: _currentFrame,
                  isTop: true,
                  width: widget.width,
                  height: halfHeight,
                  fullHeight: widget.height,
                  textStyle: widget.textStyle,
                  tileColor: widget.tileColor,
                ),
                _TileFace(
                  frame: _currentFrame,
                  isTop: false,
                  width: widget.width,
                  height: halfHeight,
                  fullHeight: widget.height,
                  textStyle: widget.textStyle,
                  tileColor: widget.tileColor,
                ),
              ],
            ),
            // Permanent center split line.
            Positioned(
              top: halfHeight - 0.5,
              left: 0,
              right: 0,
              child: Container(height: 1, color: widget.splitLineColor),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = _controller.value;
                final topProgress = (t / _topFlapSpan).clamp(0.0, 1.0);
                final bottomProgress =
                    ((t - _bottomFlapDelay) / _topFlapSpan).clamp(0.0, 1.0);

                final topDeg = lerpDouble(
                  _topFlapAngleStart,
                  _topFlapAngleEnd,
                  Curves.easeIn.transform(topProgress),
                )!;
                final bottomDeg = lerpDouble(
                  _bottomFlapAngleStart,
                  _bottomFlapAngleEnd,
                  Curves.easeOut.transform(bottomProgress),
                )!;

                // sin(progress * pi) is 0 at both ends and peaks mid-flip,
                // giving the shading a natural fade in/out for free.
                final topShade = math.sin(topProgress * math.pi) * 0.35;
                final bottomShade = math.sin(bottomProgress * math.pi) * 0.35;

                return Stack(
                  children: [
                    // Old top half, falling away.
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: halfHeight,
                      child: Transform(
                        alignment: Alignment.bottomCenter,
                        transform: _perspective()
                          ..rotateX(topDeg * math.pi / 180),
                        child: Stack(
                          children: [
                            _TileFace(
                              frame: _previousFrame,
                              isTop: true,
                              width: widget.width,
                              height: halfHeight,
                              fullHeight: widget.height,
                              textStyle: widget.textStyle,
                              tileColor: widget.tileColor,
                            ),
                            IgnorePointer(
                              child: Container(
                                color: Colors.black.withValues(alpha: topShade),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // New bottom half, unfolding into place.
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: halfHeight,
                      child: Transform(
                        alignment: Alignment.topCenter,
                        transform: _perspective()
                          ..rotateX(bottomDeg * math.pi / 180),
                        child: Stack(
                          children: [
                            _TileFace(
                              frame: _currentFrame,
                              isTop: false,
                              width: widget.width,
                              height: halfHeight,
                              fullHeight: widget.height,
                              textStyle: widget.textStyle,
                              tileColor: widget.tileColor,
                            ),
                            IgnorePointer(
                              child: Container(
                                color: Colors.black.withValues(
                                  alpha: bottomShade,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Matrix4 _perspective() => Matrix4.identity()..setEntry(3, 2, 0.0025);

/// Renders half of a tile's face: either a solid flash color, or the
/// top/bottom half of a character glyph (the full glyph is laid out at
/// [fullHeight] and clipped to the requested half via [Align.heightFactor],
/// so the text isn't visually squashed).
class _TileFace extends StatelessWidget {
  const _TileFace({
    required this.frame,
    required this.isTop,
    required this.width,
    required this.height,
    required this.fullHeight,
    required this.textStyle,
    required this.tileColor,
  });

  final _TileFrame frame;
  final bool isTop;
  final double width;
  final double height;
  final double fullHeight;
  final TextStyle textStyle;
  final Color tileColor;

  @override
  Widget build(BuildContext context) {
    if (frame.flashColor != null) {
      return SizedBox(
        width: width,
        height: height,
        child: ColoredBox(color: frame.flashColor!),
      );
    }

    return ClipRect(
      child: Align(
        alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
        heightFactor: 0.5,
        child: Container(
          width: width,
          height: fullHeight,
          color: tileColor,
          alignment: Alignment.center,
          child: Text(
            frame.char ?? ' ',
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
