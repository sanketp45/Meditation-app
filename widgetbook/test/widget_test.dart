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

    expect(find.text('HeroCompanion'), findsOneWidget);
    expect(find.text('StatsHeadline'), findsOneWidget);
    expect(find.text('TopBar'), findsOneWidget);
    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Typing'), findsOneWidget);
    expect(find.text('Filled'), findsOneWidget);
    expect(find.text('Disabled'), findsOneWidget);
    expect(find.text('3 Components • 6 Use-cases'), findsOneWidget);
  });
}
