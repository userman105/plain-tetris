import 'package:flutter/material.dart';
import '../models/tetromino.dart';
import '../theme/palette.dart';

class PiecePainter extends CustomPainter {
  final Tetromino piece;
  final double cellSize;
  final Offset origin;
  final Color color;
  final PaintingStyle style;
  final double strokeWidth;

  static const double _blockInset = 1.5;

  PiecePainter({
    required this.piece,
    required this.cellSize,
    required this.origin,
    this.color = Palette.blockFill,
    this.style = PaintingStyle.fill,
    this.strokeWidth = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (cellSize <= 0) return;
    final paint = Paint()
      ..color = color
      ..style = style
      ..strokeWidth = strokeWidth;

    for (final cell in piece.occupiedCells) {
      if (cell.row < 0) continue; // still above the visible board
      final rect = Rect.fromLTWH(
        origin.dx + cell.col * cellSize + _blockInset,
        origin.dy + cell.row * cellSize + _blockInset,
        cellSize - _blockInset * 2,
        cellSize - _blockInset * 2,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PiecePainter oldDelegate) {
    return oldDelegate.piece != piece ||
        oldDelegate.color != color ||
        oldDelegate.style != style;
  }
}