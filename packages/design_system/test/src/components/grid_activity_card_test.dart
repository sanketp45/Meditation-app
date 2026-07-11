import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:design_system/design_system.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 180, height: 180, child: child),
        ),
      );

  testWidgets('renders icon, title, range, and a single Start CTA', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const GridActivityCard(
          icon: LucideIcons.footprints,
          title: 'Walk',
          range: '10 - 100',
        ),
      ),
    );

    expect(find.byIcon(LucideIcons.footprints), findsOneWidget);
    expect(find.text('Walk'), findsOneWidget);
    expect(find.text('10 - 100'), findsOneWidget);
    expect(find.byIcon(LucideIcons.pawPrint), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    // No secondary "read more"-style affordance.
    expect(find.byIcon(LucideIcons.chevronRight), findsNothing);
  });

  testWidgets('calls onStart when tapped', (tester) async {
    var started = false;
    await tester.pumpWidget(
      wrap(
        GridActivityCard(
          icon: LucideIcons.footprints,
          title: 'Walk',
          range: '10 - 100',
          onStart: () => started = true,
        ),
      ),
    );

    await tester.tap(find.byType(GridActivityCard));
    await tester.pump();
    expect(started, isTrue);
  });

  testWidgets('tilts on press and settles back after release', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const GridActivityCard(
          icon: LucideIcons.footprints,
          title: 'Walk',
          range: '10 - 100',
        ),
      ),
    );

    final transformFinder = find.descendant(
      of: find.byType(GridActivityCard),
      matching: find.byType(Transform),
    );
    Matrix4 currentMatrix() => tester.widget<Transform>(transformFinder).transform;
    final restMatrix = currentMatrix();

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(GridActivityCard)) - const Offset(40, 40),
    );
    // A zero-duration pump first establishes the ticker's baseline; jumping
    // straight to a duration-based pump after startGesture undercounts the
    // elapsed time.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(currentMatrix(), isNot(restMatrix));

    await gesture.up();
    await tester.pumpAndSettle();
    expect(currentMatrix(), restMatrix);
  });
}
