import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:design_system/design_system.dart';

void main() {
  testWidgets('renders title, subtitle, and a chevron', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: QuoteTeaserCard(
            title: 'Quote of the day',
            subtitle: "Tap to flip today's quote",
          ),
        ),
      ),
    );

    expect(find.text('Quote of the day'), findsOneWidget);
    expect(find.text("Tap to flip today's quote"), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuoteTeaserCard(
            title: 'Quote of the day',
            subtitle: "Tap to flip today's quote",
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(QuoteTeaserCard));
    expect(tapped, isTrue);
  });
}
