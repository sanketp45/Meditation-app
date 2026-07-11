import 'package:flutter_test/flutter_test.dart';

import 'package:meditation_app/main.dart';

void main() {
  testWidgets('app boots to the home screen with both action cards', (
    tester,
  ) async {
    await tester.pumpWidget(const MeditationApp());
    await tester.pumpAndSettle();

    expect(find.text('Go for a walk'), findsOneWidget);
    expect(find.text('Breathing exercise'), findsOneWidget);
    expect(find.text('12 paws today'), findsOneWidget);
  });
}
