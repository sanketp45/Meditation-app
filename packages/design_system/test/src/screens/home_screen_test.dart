import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:design_system/design_system.dart';

void main() {
  Widget buildScreen({List<ActionCard> actionCards = const []}) {
    return MaterialApp(
      home: HomeScreen(
        initials: 'SP',
        pawCount: 12,
        companionState: CompanionState.active,
        statsSubtext: "You're on a roll today",
        splitFlapText: 'PEACE COMES FROM WITHIN',
        // Fast enough that pumpAndSettle finishes the scramble instead of
        // waiting out the full ~2s reference sequence across 48 tiles.
        splitFlapDuration: const Duration(milliseconds: 15),
        actionCards: actionCards.isEmpty
            ? const [
                ActionCard(
                  icon: LucideIcons.sportShoe,
                  title: 'Go for a walk',
                  range: '10 - 100',
                ),
                ActionCard(
                  icon: LucideIcons.wind,
                  title: 'Breathing exercise',
                  range: '5 - 20',
                ),
              ]
            : actionCards,
      ),
    );
  }

  testWidgets('renders every section in top-to-bottom order', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle(const Duration(milliseconds: 15));

    expect(find.byType(TopBar), findsOneWidget);
    expect(find.byType(HeroCompanion), findsOneWidget);
    expect(find.byType(StatsHeadline), findsOneWidget);
    expect(find.byType(SplitFlapBoard), findsOneWidget);
    expect(find.byType(ActionCard), findsNWidgets(2));

    final topBarY = tester.getTopLeft(find.byType(TopBar)).dy;
    final heroY = tester.getTopLeft(find.byType(HeroCompanion)).dy;
    final statsY = tester.getTopLeft(find.byType(StatsHeadline)).dy;
    final boardY = tester.getTopLeft(find.byType(SplitFlapBoard)).dy;
    final cardsY = tester.getTopLeft(find.byType(ActionCard).first).dy;

    expect(heroY, greaterThan(topBarY));
    expect(statsY, greaterThan(heroY));
    expect(boardY, greaterThan(statsY));
    expect(cardsY, greaterThan(boardY));
  });

  testWidgets('keeps the top bar paw count and stats headline in sync', (
    tester,
  ) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle(const Duration(milliseconds: 15));

    expect(find.text('12'), findsOneWidget); // top bar paw pill
    expect(find.text('12 paws today'), findsOneWidget); // stats headline
  });

  testWidgets('stacks multiple action cards with a 12px gap between them', (
    tester,
  ) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle(const Duration(milliseconds: 15));

    final cards = find.byType(ActionCard);
    final firstBottom = tester.getBottomLeft(cards.at(0)).dy;
    final secondTop = tester.getTopLeft(cards.at(1)).dy;

    expect(secondTop - firstBottom, closeTo(12, 0.5));
  });

  testWidgets('renders with a single action card and no crash', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildScreen(
        actionCards: const [
          ActionCard(
            icon: LucideIcons.sportShoe,
            title: 'Go for a walk',
            range: '10 - 100',
          ),
        ],
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 15));

    expect(find.byType(ActionCard), findsOneWidget);
  });

  testWidgets('the whole page is scrollable', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle(const Duration(milliseconds: 15));

    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
