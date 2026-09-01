import '../models/board.dart';
class LineClearResult {
  final int linesCleared;
  final int scoreDelta;

  const LineClearResult({required this.linesCleared, required this.scoreDelta});
}
class LineClear {
  const LineClear._();
  static const Map<int, int> _scoreTable = {1: 100, 2: 300, 3: 500, 4: 800};

  static LineClearResult apply(Board board) {
    final fullRows = <int>[];
    for (int r = 0; r < Board.rows; r++) {
      if (board.cells[r].every((occupied) => occupied)) {
        fullRows.add(r);
      }
    }

    if (fullRows.isEmpty) {
      return const LineClearResult(linesCleared: 0, scoreDelta: 0);
    }

    final remainingRows = <List<bool>>[
      for (int r = 0; r < Board.rows; r++)
        if (!fullRows.contains(r)) board.cells[r],
    ];

    final emptyRowsNeeded = fullRows.length;
    final newTopRows = List.generate(
      emptyRowsNeeded,
          (_) => List.generate(Board.columns, (_) => false),
    );

    final rebuilt = [...newTopRows, ...remainingRows];
    for (int r = 0; r < Board.rows; r++) {
      board.cells[r] = rebuilt[r];
    }

    return LineClearResult(
      linesCleared: fullRows.length,
      scoreDelta: _scoreTable[fullRows.length] ?? (fullRows.length * 200),
    );
  }
}