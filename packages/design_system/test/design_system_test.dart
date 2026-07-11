import 'package:flutter_test/flutter_test.dart';

import 'package:design_system/design_system.dart';

void main() {
  test('token classes expose the expected values', () {
    expect(AppColors.primary.toARGB32(), 0xFF6C63FF);
    expect(AppTypography.display.fontSize, 40);
    expect(AppSpacing.md, 16.0);
    expect(AppRadius.pill, 999.0);
  });
}
