class Board {
  static const int columns = 10;
  static const int rows = 20;

  final List<List<bool>> cells;

  Board()
      : cells = List.generate(
    rows,
        (_) => List.generate(columns, (_) => false),
  );

  bool isInBounds(int row, int col) {
    return col >= 0 && col < columns && row < rows;
  }

  bool isOccupied(int row, int col) {
    if (row < 0) return false;
    return cells[row][col];
  }

  void lock(int row, int col) {
    if (row < 0) return;
    cells[row][col] = true;
  }
}