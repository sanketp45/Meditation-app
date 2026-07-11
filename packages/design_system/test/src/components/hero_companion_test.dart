import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:design_system/design_system.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 400, child: child),
        ),
      );

  testWidgets('sleeping state renders the sleeping asset', (tester) async {
    await tester.pumpWidget(
      wrap(const HeroCompanion(state: CompanionState.sleeping)),
    );
    await tester.pump();

    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image as AssetImage;
    expect(provider.assetName, 'assets/companion/cat_sleeping.png');
  });

  testWidgets('active state renders the active asset', (tester) async {
    await tester.pumpWidget(
      wrap(const HeroCompanion(state: CompanionState.active)),
    );
    await tester.pump();

    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image as AssetImage;
    expect(provider.assetName, 'assets/companion/cat_active.png');
  });

  testWidgets('illustration scales down proportionally with a narrower parent', (
    tester,
  ) async {
    Future<double> imageWidthFor(double parentWidth) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: parentWidth,
              child: const HeroCompanion(state: CompanionState.active),
            ),
          ),
        ),
      );
      await tester.pump();
      return tester.getSize(find.byType(Image)).width;
    }

    final wide = await imageWidthFor(400);
    final narrow = await imageWidthFor(200);

    expect(narrow, closeTo(wide / 2, 0.5));
  });
}
