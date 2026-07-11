import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:design_system/design_system.dart';

import 'package:meditation_app/screens/quote_of_the_day_screen.dart';

void main() {
  testWidgets('shows the title and the split-flap board filling the width', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: QuoteOfTheDayScreen(
          quoteText: 'BE HERE NOW',
          splitFlapDuration: Duration(milliseconds: 15),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 15));

    expect(find.text('Quote of the day'), findsOneWidget);
    expect(find.byType(SplitFlapBoard), findsOneWidget);
    expect(find.text('B'), findsWidgets);
  });
}
