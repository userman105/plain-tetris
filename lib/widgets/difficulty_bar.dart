import 'package:flutter/material.dart';
import '../theme/palette.dart';
class DifficultyBar extends StatelessWidget {
  final int level;
  final int maxLevel;

  const DifficultyBar({super.key, required this.level, required this.maxLevel});

  static const double _segmentHeight = 10;
  static const double _segmentGap = 3;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalGap = _segmentGap * (maxLevel - 1);
        final segmentWidth = (constraints.maxWidth - totalGap) / maxLevel;

        return Row(
          children: [
            for (int i = 0; i < maxLevel; i++) ...[
              _Segment(width: segmentWidth, filled: i < level),
              if (i != maxLevel - 1) const SizedBox(width: _segmentGap),
            ],
          ],
        );
      },
    );
  }
}

class _Segment extends StatelessWidget {
  final double width;
  final bool filled;

  const _Segment({required this.width, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: DifficultyBar._segmentHeight,
      decoration: BoxDecoration(
        color: filled ? Palette.blockFill : Palette.controlOverlay,
        border: Border.all(
          color: Palette.blockOutline.withOpacity(filled ? 0.5 : 0.15),
          width: 1,
        ),
      ),
    );
  }
}