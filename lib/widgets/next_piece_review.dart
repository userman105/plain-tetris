import 'package:flutter/material.dart';
import '../models/tetromino.dart';
import '../painters/piece_painter.dart';

class NextPiecePreview extends StatelessWidget {
  final TetrominoType? type;

  const NextPiecePreview({super.key, required this.type});

  static const double _boxSize = 72;

  @override
  Widget build(BuildContext context) {
    if (type == null) {
      return const SizedBox(width: _boxSize, height: _boxSize);
    }
    return SizedBox(
      width: _boxSize,
      height: _boxSize,
      child: CustomPaint(
        size: const Size(_boxSize, _boxSize),
        painter: PiecePainter(
          piece: Tetromino(type: type!, rotationIndex: 0, col: 0, row: 0),
          cellSize: _boxSize / 4,
          origin: Offset.zero,
          color: Colors.white,
          style: PaintingStyle.stroke,
          strokeWidth: 2,
        ),
      ),
    );
  }
}