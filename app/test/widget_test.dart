import 'package:flutter_test/flutter_test.dart';

import 'package:meditation_app/main.dart';

void main() {
  testWidgets('app boots to the home screen with all four activity cards', (
    tester,
  ) async {
    await tester.pumpWidget(const MeditationApp());
    await tester.pumpAndSettle();

    expect(find.text('Walk'), findsOneWidget);
    expect(find.text('Breathe'), findsOneWidget);
    expect(find.text('Meditate'), findsOneWidget);
    expect(find.text('Stretch'), findsOneWidget);
    expect(find.text('0 paws today'), findsOneWidget);
    expect(find.text('Quote of the day'), findsOneWidget);
  });
}
