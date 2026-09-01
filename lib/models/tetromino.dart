enum TetrominoType { I, O, T, S, Z, J, L }

class GridOffset {
  final int row;
  final int col;
  const GridOffset(this.row, this.col);
}

const Map<TetrominoType, List<List<GridOffset>>> _shapes = {
  TetrominoType.I: [
    [GridOffset(1, 0), GridOffset(1, 1), GridOffset(1, 2), GridOffset(1, 3)],
    [GridOffset(0, 2), GridOffset(1, 2), GridOffset(2, 2), GridOffset(3, 2)],
    [GridOffset(2, 0), GridOffset(2, 1), GridOffset(2, 2), GridOffset(2, 3)],
    [GridOffset(0, 1), GridOffset(1, 1), GridOffset(2, 1), GridOffset(3, 1)],
  ],
  TetrominoType.O: [
    [GridOffset(1, 1), GridOffset(1, 2), GridOffset(2, 1), GridOffset(2, 2)],
    [GridOffset(1, 1), GridOffset(1, 2), GridOffset(2, 1), GridOffset(2, 2)],
    [GridOffset(1, 1), GridOffset(1, 2), GridOffset(2, 1), GridOffset(2, 2)],
    [GridOffset(1, 1), GridOffset(1, 2), GridOffset(2, 1), GridOffset(2, 2)],
  ],
  TetrominoType.T: [
    [GridOffset(0, 1), GridOffset(1, 0), GridOffset(1, 1), GridOffset(1, 2)],
    [GridOffset(0, 1), GridOffset(1, 1), GridOffset(1, 2), GridOffset(2, 1)],
    [GridOffset(1, 0), GridOffset(1, 1), GridOffset(1, 2), GridOffset(2, 1)],
    [GridOffset(0, 1), GridOffset(1, 0), GridOffset(1, 1), GridOffset(2, 1)],
  ],
  TetrominoType.S: [
    [GridOffset(0, 1), GridOffset(0, 2), GridOffset(1, 0), GridOffset(1, 1)],
    [GridOffset(0, 1), GridOffset(1, 1), GridOffset(1, 2), GridOffset(2, 2)],
    [GridOffset(1, 1), GridOffset(1, 2), GridOffset(2, 0), GridOffset(2, 1)],
    [GridOffset(0, 0), GridOffset(1, 0), GridOffset(1, 1), GridOffset(2, 1)],
  ],
  TetrominoType.Z: [
    [GridOffset(0, 0), GridOffset(0, 1), GridOffset(1, 1), GridOffset(1, 2)],
    [GridOffset(0, 2), GridOffset(1, 1), GridOffset(1, 2), GridOffset(2, 1)],
    [GridOffset(1, 0), GridOffset(1, 1), GridOffset(2, 1), GridOffset(2, 2)],
    [GridOffset(0, 1), GridOffset(1, 0), GridOffset(1, 1), GridOffset(2, 0)],
  ],
  TetrominoType.J: [
    [GridOffset(0, 0), GridOffset(1, 0), GridOffset(1, 1), GridOffset(1, 2)],
    [GridOffset(0, 1), GridOffset(0, 2), GridOffset(1, 1), GridOffset(2, 1)],
    [GridOffset(1, 0), GridOffset(1, 1), GridOffset(1, 2), GridOffset(2, 2)],
    [GridOffset(0, 1), GridOffset(1, 1), GridOffset(2, 0), GridOffset(2, 1)],
  ],
  TetrominoType.L: [
    [GridOffset(0, 2), GridOffset(1, 0), GridOffset(1, 1), GridOffset(1, 2)],
    [GridOffset(0, 1), GridOffset(1, 1), GridOffset(2, 1), GridOffset(2, 2)],
    [GridOffset(1, 0), GridOffset(1, 1), GridOffset(1, 2), GridOffset(2, 0)],
    [GridOffset(0, 0), GridOffset(0, 1), GridOffset(1, 1), GridOffset(2, 1)],
  ],
};


class Tetromino {
  final TetrominoType type;
  final int rotationIndex; // 0-3
  final int col;
  final int row;

  const Tetromino({
    required this.type,
    required this.rotationIndex,
    required this.col,
    required this.row,
  });

  factory Tetromino.spawn(TetrominoType type, {required int boardColumns}) {
    return Tetromino(
      type: type,
      rotationIndex: 0,
      col: (boardColumns - 4) ~/ 2,
      row: 0,
    );
  }

  List<GridOffset> get occupiedCells {
    final offsets = _shapes[type]![rotationIndex];
    return offsets
        .map((o) => GridOffset(o.row + row, o.col + col))
        .toList(growable: false);
  }

  Tetromino rotatedClockwise() =>
      copyWith(rotationIndex: (rotationIndex + 1) % 4);

  Tetromino rotatedCounterClockwise() =>
      copyWith(rotationIndex: (rotationIndex + 3) % 4);

  Tetromino moved({int deltaRow = 0, int deltaCol = 0}) =>
      copyWith(row: row + deltaRow, col: col + deltaCol);

  Tetromino copyWith({
    TetrominoType? type,
    int? rotationIndex,
    int? col,
    int? row,
  }) {
    return Tetromino(
      type: type ?? this.type,
      rotationIndex: rotationIndex ?? this.rotationIndex,
      col: col ?? this.col,
      row: row ?? this.row,
    );
  }
}