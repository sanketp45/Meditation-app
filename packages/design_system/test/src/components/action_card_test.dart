import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:design_system/design_system.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders icon, title, range, paw icon, and chevron', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const ActionCard(
          icon: LucideIcons.sportShoe,
          title: 'Go for a walk',
          range: '10 - 100',
        ),
      ),
    );

    expect(find.byIcon(LucideIcons.sportShoe), findsOneWidget);
    expect(find.text('Go for a walk'), findsOneWidget);
    expect(find.text('10 - 100'), findsOneWidget);
    expect(find.byIcon(LucideIcons.pawPrint), findsOneWidget);
    expect(find.byIcon(LucideIcons.chevronRight), findsOneWidget);

    final leadingIcon = tester.widget<Icon>(
      find.byIcon(LucideIcons.sportShoe),
    );
    expect(leadingIcon.size, 32);
    expect(leadingIcon.color, AppColors.primary);

    final title = tester.widget<Text>(find.text('Go for a walk'));
    expect(title.style?.fontFamily, 'Quicksand');
    expect(title.style?.fontSize, 16);
    expect(title.style?.fontWeight, FontWeight.w600);
    expect(title.style?.color, AppColors.textPrimary);

    final range = tester.widget<Text>(find.text('10 - 100'));
    expect(range.style?.fontSize, 14);
    expect(range.style?.fontWeight, FontWeight.w500);
    expect(range.style?.color, AppColors.textSecondary);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        ActionCard(
          icon: LucideIcons.sportShoe,
          title: 'Go for a walk',
          range: '10 - 100',
          onTap: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.byType(ActionCard));
    expect(tapped, isTrue);
  });
}
