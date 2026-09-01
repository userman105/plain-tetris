import 'dart:math';
import 'package:flutter/material.dart';
import '../logic/game_controller.dart';
import '../models/board.dart';
import '../painters/board_painter.dart';
import '../painters/piece_painter.dart';
import '../theme/palette.dart';

/// The real board: no longer edge-to-edge. It's inset from the
/// screen with margin (leaving room for the HUD above/below and
/// shrinking the blocks in the process) and wrapped in a dark
/// outlined frame so it reads as a distinct panel rather than the
/// whole background. Grid lines + locked blocks + the falling piece
/// are layered inside that frame. Rebuilds whenever [controller]
/// notifies listeners.
class GameBoardWidget extends StatelessWidget {
  final GameController controller;

  const GameBoardWidget({super.key, required this.controller});

  /// Space reserved around the board for the HUD (difficulty bar,
  /// next-piece preview, pause button up top; movement controls
  /// below) and to keep the board from touching the screen edges.
  static const EdgeInsets _margin = EdgeInsets.fromLTRB(20, 100, 20, 100);

  static const double _borderWidth = 3;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Padding(
          padding: _margin,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth - _borderWidth * 2;
              final availableHeight = constraints.maxHeight - _borderWidth * 2;
              final cellSize = min(
                availableWidth / Board.columns,
                availableHeight / Board.rows,
              );
              final boardWidth = cellSize * Board.columns;
              final boardHeight = cellSize * Board.rows;
              final canvasSize = Size(boardWidth, boardHeight);

              return Center(
                child: Container(
                  width: boardWidth + _borderWidth * 2,
                  height: boardHeight + _borderWidth * 2,
                  decoration: BoxDecoration(
                    color: Palette.background,
                    border: Border.all(
                      color: Palette.blockOutline,
                      width: _borderWidth,
                    ),
                  ),
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: canvasSize,
                        painter: BoardPainter(
                          board: controller.board,
                          cellSize: cellSize,
                          origin: Offset.zero,
                        ),
                      ),
                      if (controller.ghostPiece != null)
                        CustomPaint(
                          size: canvasSize,
                          painter: PiecePainter(
                            piece: controller.ghostPiece!,
                            cellSize: cellSize,
                            origin: Offset.zero,
                            color: Palette.blockOutline,
                            style: PaintingStyle.stroke,
                            strokeWidth: 2,
                          ),
                        ),
                      if (controller.currentPiece != null)
                        CustomPaint(
                          size: canvasSize,
                          painter: PiecePainter(
                            piece: controller.currentPiece!,
                            cellSize: cellSize,
                            origin: Offset.zero,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}