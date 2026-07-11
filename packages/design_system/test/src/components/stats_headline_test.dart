import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:design_system/design_system.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('pluralizes to "paws" for zero and multi-digit counts', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const StatsHeadline(pawCount: 0, subtext: 'Complete a session to start'),
      ),
    );

    expect(find.text('0 paws today'), findsOneWidget);
    expect(find.text('Complete a session to start'), findsOneWidget);
  });

  testWidgets('singularizes to "paw" for a count of exactly one', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const StatsHeadline(pawCount: 1, subtext: 'Nice start')),
    );

    expect(find.text('1 paw today'), findsOneWidget);
  });

  testWidgets('renders correctly for a triple-digit count', (tester) async {
    await tester.pumpWidget(
      wrap(const StatsHeadline(pawCount: 128, subtext: "You're on a roll")),
    );

    expect(find.text('128 paws today'), findsOneWidget);

    final headline = tester.widget<Text>(find.text('128 paws today'));
    expect(headline.style?.fontFamily, 'Quicksand');
    expect(headline.style?.fontSize, 24);
    expect(headline.style?.fontWeight, FontWeight.w600);
    expect(headline.style?.color, AppColors.textPrimary);

    final subtext = tester.widget<Text>(find.text("You're on a roll"));
    expect(subtext.style?.fontSize, 14);
    expect(subtext.style?.fontWeight, FontWeight.w400);
    expect(subtext.style?.color, AppColors.textSecondary);
  });
}
