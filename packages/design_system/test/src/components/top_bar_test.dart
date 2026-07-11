import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:design_system/design_system.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: child));

  testWidgets('default state: empty, unfocused, placeholder shown', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const TopBar(initials: 'SP', pawCount: 128)),
    );

    expect(find.text('SP'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.byIcon(LucideIcons.search), findsOneWidget);
    expect(find.byIcon(LucideIcons.pawPrint), findsOneWidget);
    expect(find.byIcon(LucideIcons.sparkles), findsOneWidget);
    expect(find.byIcon(LucideIcons.x), findsNothing);

    final icon = tester.widget<Icon>(
      find.byIcon(LucideIcons.search),
    );
    expect(icon.color, AppColors.textSecondary);
  });

  testWidgets('typing state: focusing the field highlights it', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const TopBar(initials: 'SP', pawCount: 128, searchAutofocus: true)),
    );
    await tester.pump();

    final icon = tester.widget<Icon>(
      find.byIcon(LucideIcons.search),
    );
    expect(icon.color, AppColors.primary);
  });

  testWidgets('filled state: entered text shows a clear button', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'yoga nidra');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        TopBar(
          initials: 'SP',
          pawCount: 128,
          searchController: controller,
        ),
      ),
    );

    expect(find.text('yoga nidra'), findsOneWidget);
    expect(find.byIcon(LucideIcons.x), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.x));
    await tester.pump();

    expect(controller.text, isEmpty);
    expect(find.byIcon(LucideIcons.x), findsNothing);
  });

  testWidgets('disabled state: field is non-interactive and dimmed', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const TopBar(initials: 'SP', pawCount: 128, enabled: false)),
    );

    // TopBar wraps its whole row in one Opacity/IgnorePointer pair; scope to
    // descendants of TopBar and take the outermost match, since TextField's
    // internals (and MaterialApp's) add their own elsewhere in the tree.
    final opacity = tester.firstWidget<Opacity>(
      find.descendant(of: find.byType(TopBar), matching: find.byType(Opacity)),
    );
    expect(opacity.opacity, lessThan(1));

    final ignorePointer = tester.firstWidget<IgnorePointer>(
      find.descendant(
        of: find.byType(TopBar),
        matching: find.byType(IgnorePointer),
      ),
    );
    expect(ignorePointer.ignoring, isTrue);

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.enabled, isFalse);
  });
}
