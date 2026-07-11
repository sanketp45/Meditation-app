import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:design_system/design_system.dart';

void main() {
  testWidgets('TopBar renders initials, placeholder, and paw count', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TopBar(initials: 'SP', pawCount: 128),
        ),
      ),
    );

    expect(find.text('SP'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.pets), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
  });
}
