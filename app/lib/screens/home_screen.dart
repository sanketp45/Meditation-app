import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'quote_of_the_day_screen.dart';

/// The home screen: assembles [TopBar], [HeroCompanion], [StatsHeadline],
/// a [QuoteTeaserCard] linking out to the quote-of-the-day board, and a
/// 2-column grid of [GridActivityCard]s into a single scrollable page.
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
    required this.activityCards,
    this.quoteTeaserSubtitle = "Tap to flip today's quote",
    this.activityGridHeading = 'Start stretching and start earning',
    this.onAvatarTap,
    this.onSearchChanged,
    this.onAssistantTap,
  });

  final String initials;
  final int pawCount;
  final CompanionState companionState;
  final String statsSubtext;

  /// The quote shown on the [QuoteOfTheDayScreen] this screen navigates to.
  final String splitFlapText;
  final String quoteTeaserSubtitle;
  final String activityGridHeading;

  /// Fully-built [GridActivityCard] widgets, laid out 2 per row.
  /// Constructing them at the call site (rather than a parallel data model)
  /// keeps this screen a straightforward assembly of the components
  /// already built, nothing more.
  final List<GridActivityCard> activityCards;

  final VoidCallback? onAvatarTap;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onAssistantTap;

  static const double _horizontalPadding = AppSpacing.md; // 16
  static const double _safeAreaTopGap = 12;
  static const double _sectionGap = AppSpacing.lg; // 24
  static const double _heroToStatsGap = AppSpacing.xs; // 4
  static const double _gridGap = 12;
  static const double _bottomPadding = AppSpacing.xl; // 32
  static const double _heroStageRadius = 48;

  /// How much of the hero stage's resolved height the white "ground" shape
  /// rises to cover, measured from the bottom. The companion illustration
  /// paints on top of both this and the cream fill (it's part of the
  /// foreground content, not the background), so its lower portion visually
  /// bleeds across the curved boundary rather than sitting fully above it.
  static const double _heroGroundHeightFactor = 0.30;

  void _openQuoteOfTheDay(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuoteOfTheDayScreen(quoteText: splitFlapText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // White below the hero stage; the stage itself (top bar + hero
      // companion) carries its own cream background so only that section
      // reads as "sky", matching the reference — not the whole page.
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: AppColors.background),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: _heroGroundHeightFactor,
                        widthFactor: 1,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(_heroStageRadius),
                              topRight: Radius.circular(_heroStageRadius),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: _safeAreaTopGap),
                      // TopBar already carries its own 16px internal
                      // padding, so it renders full-bleed here too.
                      TopBar(
                        initials: initials,
                        pawCount: pawCount,
                        onAvatarTap: onAvatarTap,
                        onSearchChanged: onSearchChanged,
                        onAssistantTap: onAssistantTap,
                      ),
                      const SizedBox(height: _sectionGap),
                      // No horizontal padding: HeroCompanion needs the full
                      // screen width so its glow is genuinely edge-to-edge.
                      HeroCompanion(state: companionState),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: _heroToStatsGap),
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
                child: QuoteTeaserCard(
                  title: 'Quote of the day',
                  subtitle: quoteTeaserSubtitle,
                  onTap: () => _openQuoteOfTheDay(context),
                ),
              ),
              const SizedBox(height: _sectionGap),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: Text(
                  activityGridHeading,
                  style: AppTypography.title.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: _sectionGap),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: _ActivityGrid(cards: activityCards, gap: _gridGap),
              ),
              const SizedBox(height: _bottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lays [cards] out 2 per row with [gap] between columns and rows. The last
/// row is padded with an empty cell if [cards] has an odd length.
class _ActivityGrid extends StatelessWidget {
  const _ActivityGrid({required this.cards, required this.gap});

  final List<GridActivityCard> cards;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < cards.length; i += 2) ...[
          if (i > 0) SizedBox(height: gap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards[i]),
              SizedBox(width: gap),
              Expanded(
                child: i + 1 < cards.length
                    ? cards[i + 1]
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
