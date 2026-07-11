import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:meditation_app_widgetbook/main.dart';

void main() {
  testWidgets('Widgetbook app boots and lists all components', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MeditationAppWidgetbook());
    await tester.pumpAndSettle();

    expect(find.text('ActionCard'), findsOneWidget);
    expect(find.text('HeroCompanion'), findsOneWidget);
    expect(find.text('SplitFlapBoard'), findsOneWidget);
    expect(find.text('Mid animation'), findsOneWidget);
    expect(find.text('Settled'), findsOneWidget);
    expect(find.text('StatsHeadline'), findsOneWidget);
    expect(find.text('TopBar'), findsOneWidget);
    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Typing'), findsOneWidget);
    expect(find.text('Filled'), findsOneWidget);
    expect(find.text('Disabled'), findsOneWidget);
    expect(find.text('Screens'), findsNothing);
    expect(find.text('HomeScreen'), findsNothing);
    expect(find.text('5 Components • 9 Use-cases'), findsOneWidget);
  });
}
