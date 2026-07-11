import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:meditation_app/screens/home_screen.dart';
import 'package:meditation_app/screens/quote_of_the_day_screen.dart';

void main() {
  Widget buildScreen({List<GridActivityCard> activityCards = const []}) {
    return MaterialApp(
      home: HomeScreen(
        initials: 'SP',
        pawCount: 12,
        companionState: CompanionState.active,
        statsSubtext: "You're on a roll today",
        splitFlapText: 'PEACE COMES FROM WITHIN',
        activityCards: activityCards.isEmpty
            ? const [
                GridActivityCard(
                  icon: LucideIcons.sportShoe,
                  title: 'Walk',
                  range: '10 - 100',
                ),
                GridActivityCard(
                  icon: LucideIcons.wind,
                  title: 'Breathe',
                  range: '5 - 20',
                ),
                GridActivityCard(
                  icon: LucideIcons.flower,
                  title: 'Meditate',
                  range: '20 - 50',
                ),
                GridActivityCard(
                  icon: LucideIcons.personStanding,
                  title: 'Stretch',
                  range: '10 - 30',
                ),
              ]
            : activityCards,
      ),
    );
  }

  testWidgets('renders every section in top-to-bottom order', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.byType(TopBar), findsOneWidget);
    expect(find.byType(HeroCompanion), findsOneWidget);
    expect(find.byType(StatsHeadline), findsOneWidget);
    expect(find.byType(QuoteTeaserCard), findsOneWidget);
    expect(find.text('Start stretching and start earning'), findsOneWidget);
    expect(find.byType(GridActivityCard), findsNWidgets(4));

    final topBarY = tester.getTopLeft(find.byType(TopBar)).dy;
    final heroY = tester.getTopLeft(find.byType(HeroCompanion)).dy;
    final statsY = tester.getTopLeft(find.byType(StatsHeadline)).dy;
    final teaserY = tester.getTopLeft(find.byType(QuoteTeaserCard)).dy;
    final gridY = tester.getTopLeft(find.byType(GridActivityCard).first).dy;

    expect(heroY, greaterThan(topBarY));
    expect(statsY, greaterThan(heroY));
    expect(teaserY, greaterThan(statsY));
    expect(gridY, greaterThan(teaserY));
  });

  testWidgets('keeps the top bar paw count and stats headline in sync', (
    tester,
  ) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('12'), findsOneWidget); // top bar paw pill
    expect(find.text('12 paws today'), findsOneWidget); // stats headline
  });

  testWidgets('leaves only a 4px gap between the hero image and the headline', (
    tester,
  ) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    final heroBottom = tester.getBottomLeft(find.byType(HeroCompanion)).dy;
    final statsTop = tester.getTopLeft(find.byType(StatsHeadline)).dy;

    expect(statsTop - heroBottom, closeTo(4, 0.5));
  });

  testWidgets('lays out activity cards 2 per row with a 12px gap', (
    tester,
  ) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    final cards = find.byType(GridActivityCard);
    final topLeft = tester.getTopLeft(cards.at(0));
    final topRight = tester.getTopLeft(cards.at(1));
    final secondRowLeft = tester.getTopLeft(cards.at(2));

    // Same row: same Y, different X (side by side).
    expect(topRight.dy, closeTo(topLeft.dy, 0.5));
    expect(topRight.dx, greaterThan(topLeft.dx));

    // Next row starts 12px below the first row's bottom edge.
    final firstRowBottom = tester.getBottomLeft(cards.at(0)).dy;
    expect(secondRowLeft.dy - firstRowBottom, closeTo(12, 0.5));
  });

  testWidgets('tapping the quote teaser navigates to the quote of the day screen', (
    tester,
  ) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(QuoteTeaserCard));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(QuoteTeaserCard));
    await tester.pumpAndSettle(const Duration(milliseconds: 15));

    expect(find.byType(QuoteOfTheDayScreen), findsOneWidget);
    expect(find.text('Quote of the day'), findsOneWidget);
    expect(find.byType(SplitFlapBoard), findsOneWidget);
  });

  testWidgets('handles an odd number of activity cards without crashing', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildScreen(
        activityCards: const [
          GridActivityCard(
            icon: LucideIcons.sportShoe,
            title: 'Walk',
            range: '10 - 100',
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GridActivityCard), findsOneWidget);
  });

  testWidgets('the whole page is scrollable', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
