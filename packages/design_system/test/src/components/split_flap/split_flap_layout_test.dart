import 'package:flutter_test/flutter_test.dart';

import 'package:design_system/src/components/split_flap/split_flap_layout.dart';

String _render(List<List<String>> grid) =>
    grid.map((row) => row.join()).join('\n');

void main() {
  test('short word is centered on the middle row', () {
    final grid = buildSplitFlapGrid('HI', columns: 12, rows: 4);

    expect(grid.length, 4);
    expect(grid[0].every((c) => c == ' '), isTrue);
    expect(grid[3].every((c) => c == ' '), isTrue);
    // 'HI' (2 chars) centered in 12 columns -> 5 spaces of left padding.
    expect(grid[1].join(), '     HI     ');
    expect(grid[2].every((c) => c == ' '), isTrue);
  });

  test('uppercases input', () {
    final grid = buildSplitFlapGrid('hi', columns: 12, rows: 4);
    expect(_render(grid), contains('HI'));
  });

  test('word-wraps long text across multiple lines within the column limit', () {
    final grid = buildSplitFlapGrid(
      'THE QUICK BROWN FOX',
      columns: 12,
      rows: 4,
    );

    for (final row in grid) {
      expect(row.length, 12);
    }
    final nonBlankLines = grid.where((r) => r.any((c) => c != ' ')).toList();
    expect(nonBlankLines.length, greaterThan(1));
    for (final row in grid) {
      expect(row.join().trim().length, lessThanOrEqualTo(12));
    }
  });

  test('honors explicit line breaks', () {
    final grid = buildSplitFlapGrid('AB\nCD', columns: 12, rows: 4);
    final lines = grid.map((r) => r.join().trim()).where((l) => l.isNotEmpty).toList();
    expect(lines, ['AB', 'CD']);
  });

  test('hard-breaks a word longer than the column count', () {
    final grid = buildSplitFlapGrid('A' * 15, columns: 12, rows: 4);
    final nonBlankLines = grid.where((r) => r.any((c) => c != ' ')).toList();
    expect(nonBlankLines.length, 2);
    expect(nonBlankLines[0].join().trim().length, 12);
  });

  test('truncates to the first N rows when text overflows the grid', () {
    final grid = buildSplitFlapGrid('ONE\nTWO\nTHREE\nFOUR\nFIVE\nSIX', columns: 12, rows: 4);
    expect(grid.length, 4);
  });

  test('every row always has exactly `columns` cells', () {
    final grid = buildSplitFlapGrid('', columns: 12, rows: 4);
    expect(grid.length, 4);
    for (final row in grid) {
      expect(row.length, 12);
      expect(row.every((c) => c == ' '), isTrue);
    }
  });
}
