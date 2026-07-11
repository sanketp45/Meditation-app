import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const MeditationAppWidgetbook());
}

class MeditationAppWidgetbook extends StatelessWidget {
  const MeditationAppWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookCategory(
          name: 'Components',
          children: [
            WidgetbookComponent(
              name: 'ActionCard',
              useCases: [
                WidgetbookUseCase(
                  name: 'Walk',
                  builder: (context) => const _ActionCardWalkPreview(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'HeroCompanion',
              useCases: [
                WidgetbookUseCase(
                  name: 'States side by side',
                  builder: (context) => const _HeroCompanionStatesPreview(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'SplitFlapBoard',
              useCases: [
                WidgetbookUseCase(
                  name: 'Mid animation',
                  builder: (context) => const _SplitFlapBoardPreview(
                    label: 'Mid animation (live — scrambling on load)',
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Settled',
                  builder: (context) => const _SplitFlapBoardPreview(
                    label: 'Settled',
                    autoPlay: false,
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'StatsHeadline',
              useCases: [
                WidgetbookUseCase(
                  name: 'Single vs triple digit count',
                  builder: (context) => const _StatsHeadlineCountsPreview(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'TopBar',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => const _TopBarPreview(),
                ),
                WidgetbookUseCase(
                  name: 'Typing',
                  builder: (context) => const _TopBarPreview(
                    searchAutofocus: true,
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Filled',
                  builder: (context) => const _TopBarPreview(
                    searchText: 'yoga nidra',
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Disabled',
                  builder: (context) => const _TopBarPreview(
                    enabled: false,
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Screens',
          children: [
            WidgetbookComponent(
              name: 'HomeScreen',
              useCases: [
                WidgetbookUseCase(
                  name: 'Assembled page',
                  builder: (context) => const _HomeScreenPreview(),
                ),
              ],
            ),
          ],
        ),
      ],
      addons: [
        ThemeAddon<ThemeData>(
          themes: [
            WidgetbookTheme(name: 'Light', data: ThemeData.light()),
            WidgetbookTheme(name: 'Dark', data: ThemeData.dark()),
          ],
          themeBuilder: (context, theme, child) => Theme(
            data: theme,
            child: child,
          ),
        ),
      ],
    );
  }
}

class _HomeScreenPreview extends StatelessWidget {
  const _HomeScreenPreview();

  @override
  Widget build(BuildContext context) {
    // HomeScreen owns its own Scaffold/background, so it's rendered
    // directly rather than wrapped like the other, smaller UseCases.
    return HomeScreen(
      initials: 'SP',
      pawCount: 12,
      companionState: CompanionState.active,
      statsSubtext: "You're on a roll today",
      splitFlapText: 'PEACE COMES FROM WITHIN',
      actionCards: [
        ActionCard(
          icon: LucideIcons.sportShoe,
          title: 'Go for a walk',
          range: '10 - 100',
          onTap: () {},
        ),
        ActionCard(
          icon: LucideIcons.wind,
          title: 'Breathing exercise',
          range: '5 - 20',
          onTap: () {},
        ),
      ],
    );
  }
}

class _ActionCardWalkPreview extends StatelessWidget {
  const _ActionCardWalkPreview();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ActionCard(
            icon: LucideIcons.sportShoe,
            title: 'Go for a walk',
            range: '10 - 100',
            onTap: () {},
          ),
        ),
      ),
    );
  }
}

class _HeroCompanionStatesPreview extends StatelessWidget {
  const _HeroCompanionStatesPreview();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: _HeroCompanionLabeled(
                  label: 'Sleeping (no activity yet)',
                  state: CompanionState.sleeping,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _HeroCompanionLabeled(
                  label: 'Active (activity logged)',
                  state: CompanionState.active,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCompanionLabeled extends StatelessWidget {
  const _HeroCompanionLabeled({required this.label, required this.state});

  final String label;
  final CompanionState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
        HeroCompanion(state: state),
      ],
    );
  }
}

const String _splitFlapSampleQuote = 'PEACE COMES FROM WITHIN';

class _SplitFlapBoardPreview extends StatelessWidget {
  const _SplitFlapBoardPreview({required this.label, this.autoPlay = true});

  final String label;
  final bool autoPlay;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SplitFlapBoard(
                text: _splitFlapSampleQuote,
                autoPlay: autoPlay,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsHeadlineCountsPreview extends StatelessWidget {
  const _StatsHeadlineCountsPreview();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: const [
              _StatsHeadlineLabeled(
                label: 'Single digit count',
                pawCount: 3,
                subtext: 'Complete a session to earn more',
              ),
              SizedBox(height: AppSpacing.xl),
              _StatsHeadlineLabeled(
                label: 'Triple digit count',
                pawCount: 128,
                subtext: "You're on a roll today",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsHeadlineLabeled extends StatelessWidget {
  const _StatsHeadlineLabeled({
    required this.label,
    required this.pawCount,
    required this.subtext,
  });

  final String label;
  final int pawCount;
  final String subtext;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        StatsHeadline(pawCount: pawCount, subtext: subtext),
      ],
    );
  }
}

class _TopBarPreview extends StatefulWidget {
  const _TopBarPreview({
    this.searchAutofocus = false,
    this.searchText,
    this.enabled = true,
  });

  final bool searchAutofocus;
  final String? searchText;
  final bool enabled;

  @override
  State<_TopBarPreview> createState() => _TopBarPreviewState();
}

class _TopBarPreviewState extends State<_TopBarPreview> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.searchText != null) {
      _controller = TextEditingController(text: widget.searchText);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: TopBar(
          initials: 'SP',
          pawCount: 128,
          searchAutofocus: widget.searchAutofocus,
          searchController: _controller,
          enabled: widget.enabled,
        ),
      ),
    );
  }
}
