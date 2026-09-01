import 'package:flutter/material.dart';
import '../models/board.dart';
import '../theme/palette.dart';

class BoardPainter extends CustomPainter {
  final Board board;
  final double cellSize;
  final Offset origin;

  static const double _blockInset = 1.5;

  BoardPainter({
    required this.board,
    required this.cellSize,
    required this.origin,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (cellSize <= 0) return;

    final boardWidth = cellSize * Board.columns;
    final boardHeight = cellSize * Board.rows;

    final gridPaint = Paint()
      ..color = Palette.gridLine
      ..strokeWidth = 1;

    for (int c = 0; c <= Board.columns; c++) {
      final x = origin.dx + c * cellSize;
      canvas.drawLine(Offset(x, origin.dy), Offset(x, origin.dy + boardHeight), gridPaint);
    }
    for (int r = 0; r <= Board.rows; r++) {
      final y = origin.dy + r * cellSize;
      canvas.drawLine(Offset(origin.dx, y), Offset(origin.dx + boardWidth, y), gridPaint);
    }

    final blockPaint = Paint()..color = Palette.blockFill;
    for (int r = 0; r < Board.rows; r++) {
      for (int c = 0; c < Board.columns; c++) {
        if (!board.cells[r][c]) continue;
        final rect = Rect.fromLTWH(
          origin.dx + c * cellSize + _blockInset,
          origin.dy + r * cellSize + _blockInset,
          cellSize - _blockInset * 2,
          cellSize - _blockInset * 2,
        );
        canvas.drawRect(rect, blockPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return true;
  }
}