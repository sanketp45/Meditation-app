/// Pure text-layout logic for the split-flap board, kept independent of
/// Flutter widgets so it can be unit tested without pumping a widget tree.
library;

/// Word-wraps [text] to fit [columns] characters per line, honoring explicit
/// `\n` line breaks, then centers the resulting lines both vertically and
/// horizontally within a [rows] x [columns] grid.
///
/// Words longer than [columns] are hard-broken. If more lines are produced
/// than [rows] can hold, the layout is truncated to the first [rows] lines —
/// the board is a fixed physical grid, it can't grow to fit arbitrary text.
/// Unfilled cells are spaces.
List<List<String>> buildSplitFlapGrid(
  String text, {
  required int columns,
  required int rows,
}) {
  final lines = _wrapLines(text.toUpperCase(), columns);
  final visibleLines = lines.length > rows ? lines.sublist(0, rows) : lines;

  final grid = List.generate(rows, (_) => List.filled(columns, ' '));
  final topPad = ((rows - visibleLines.length) / 2).floor();

  for (var lineIndex = 0; lineIndex < visibleLines.length; lineIndex++) {
    final line = visibleLines[lineIndex];
    final leftPad = ((columns - line.length) / 2).floor();
    final row = topPad + lineIndex;
    for (var col = 0; col < line.length; col++) {
      grid[row][leftPad + col] = line[col];
    }
  }

  return grid;
}

List<String> _wrapLines(String text, int columns) {
  final lines = <String>[];

  for (final paragraph in text.split('\n')) {
    final words = paragraph.split(' ').where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) {
      lines.add('');
      continue;
    }

    var current = '';
    for (var word in words) {
      while (word.length > columns) {
        if (current.isNotEmpty) {
          lines.add(current);
          current = '';
        }
        lines.add(word.substring(0, columns));
        word = word.substring(columns);
      }

      final candidate = current.isEmpty ? word : '$current $word';
      if (candidate.length <= columns) {
        current = candidate;
      } else {
        lines.add(current);
        current = word;
      }
    }
    if (current.isNotEmpty) {
      lines.add(current);
    }
  }

  return lines;
}
