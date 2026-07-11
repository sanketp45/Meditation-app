import 'package:flutter/material.dart';

import '../../generated/app_colors.dart';
import '../../generated/app_spacing.dart';
import '../components/action_card.dart';
import '../components/hero_companion.dart';
import '../components/split_flap_board.dart';
import '../components/stats_headline.dart';
import '../components/top_bar.dart';

/// The home screen: assembles [TopBar], [HeroCompanion], [StatsHeadline],
/// [SplitFlapBoard], and a stack of [ActionCard]s into a single scrollable
/// page.
///
/// [pawCount] is passed to both the top bar's paw pill and the stats
/// headline directly, so the two stay in sync at the data level — per
/// their own docs, neither component is aware of the other.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.initials,
    required this.pawCount,
    required this.companionState,
    required this.statsSubtext,
    required this.splitFlapText,
    required this.actionCards,
    this.onAvatarTap,
    this.onSearchChanged,
    this.onAssistantTap,
    this.splitFlapDuration = const Duration(milliseconds: 350),
  });

  final String initials;
  final int pawCount;
  final CompanionState companionState;
  final String statsSubtext;
  final String splitFlapText;

  /// Fully-built [ActionCard] widgets, stacked in order with a gap between
  /// each. Constructing them at the call site (rather than a parallel data
  /// model) keeps this screen a straightforward assembly of the components
  /// already built, nothing more.
  final List<ActionCard> actionCards;

  final VoidCallback? onAvatarTap;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onAssistantTap;

  /// Forwarded to the split-flap board's `duration`. Overridable mainly so
  /// tests aren't stuck waiting out the full reference scramble length.
  final Duration splitFlapDuration;

  static const double _horizontalPadding = AppSpacing.md; // 16
  static const double _safeAreaTopGap = 12;
  static const double _sectionGap = AppSpacing.lg; // 24
  static const double _cardGap = 12;
  static const double _bottomPadding = AppSpacing.xl; // 32

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: _safeAreaTopGap),
              TopBar(
                initials: initials,
                pawCount: pawCount,
                onAvatarTap: onAvatarTap,
                onSearchChanged: onSearchChanged,
                onAssistantTap: onAssistantTap,
              ),
              const SizedBox(height: _sectionGap),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: HeroCompanion(state: companionState),
              ),
              const SizedBox(height: _sectionGap),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: StatsHeadline(
                  pawCount: pawCount,
                  subtext: statsSubtext,
                ),
              ),
              const SizedBox(height: _sectionGap),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: SplitFlapBoard(
                  text: splitFlapText,
                  duration: splitFlapDuration,
                ),
              ),
              const SizedBox(height: _sectionGap),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < actionCards.length; i++) ...[
                      if (i > 0) const SizedBox(height: _cardGap),
                      actionCards[i],
                    ],
                  ],
                ),
              ),
              const SizedBox(height: _bottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}
