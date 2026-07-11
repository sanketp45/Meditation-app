import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:design_system/design_system.dart';
import 'package:design_system/src/components/split_flap/split_flap_tile.dart';

Widget _wrap(Widget child, {double width = 400}) => MaterialApp(
      home: Scaffold(
        body: SizedBox(width: width, child: child),
      ),
    );

void main() {
  testWidgets('renders a 12x4 grid of tiles', (tester) async {
    await tester.pumpWidget(
      _wrap(const SplitFlapBoard(text: 'HI', autoPlay: false)),
    );
    await tester.pump();

    expect(find.byType(SplitFlapTile), findsNWidgets(48));
  });

  testWidgets('autoPlay: false shows the target text immediately, no animation', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const SplitFlapBoard(text: 'HI', autoPlay: false)),
    );
    await tester.pump();

    expect(find.text('H'), findsWidgets);
    expect(find.text('I'), findsWidgets);

    // No timers should be pending since nothing is scrambling.
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('settles on the target characters once the scramble completes', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const SplitFlapBoard(
          text: 'HI',
          duration: Duration(milliseconds: 20),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(milliseconds: 20));

    expect(find.text('H'), findsWidgets);
    expect(find.text('I'), findsWidgets);
  });

  testWidgets('word-wraps and centers multi-word text before settling', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const SplitFlapBoard(
          text: 'BE HERE NOW',
          duration: Duration(milliseconds: 20),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(milliseconds: 20));

    expect(find.text('B'), findsWidgets);
    expect(find.text('E'), findsWidgets);
    expect(find.text('H'), findsWidgets);
    expect(find.text('N'), findsWidgets);
    expect(find.text('O'), findsWidgets);
    expect(find.text('W'), findsWidgets);
  });

  testWidgets('re-scrambles when the text input changes', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SplitFlapBoard(text: 'HI', duration: Duration(milliseconds: 20)),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 20));
    expect(find.text('H'), findsWidgets);

    await tester.pumpWidget(
      _wrap(
        const SplitFlapBoard(text: 'OK', duration: Duration(milliseconds: 20)),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 20));

    expect(find.text('O'), findsWidgets);
    expect(find.text('K'), findsWidgets);
  });
}
