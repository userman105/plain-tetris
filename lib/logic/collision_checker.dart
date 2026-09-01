import '../models/board.dart';
import '../models/tetromino.dart';
class CollisionChecker {
  const CollisionChecker._();
  static bool isValidPosition(Tetromino piece, Board board) {
    for (final cell in piece.occupiedCells) {
      if (!board.isInBounds(cell.row, cell.col)) return false;
      if (board.isOccupied(cell.row, cell.col)) return false;
    }
    return true;
  }

  static bool canMoveDown(Tetromino piece, Board board) {
    return isValidPosition(piece.moved(deltaRow: 1), board);
  }

  static bool canMoveLeft(Tetromino piece, Board board) {
    return isValidPosition(piece.moved(deltaCol: -1), board);
  }

  static bool canMoveRight(Tetromino piece, Board board) {
    return isValidPosition(piece.moved(deltaCol: 1), board);
  }

  static bool canRotateClockwise(Tetromino piece, Board board) {
    return isValidPosition(piece.rotatedClockwise(), board);
  }

  static bool canRotateCounterClockwise(Tetromino piece, Board board) {
    return isValidPosition(piece.rotatedCounterClockwise(), board);
  }

  static bool isGameOver(Tetromino piece, Board board) {
    return !isValidPosition(piece, board);
  }
}