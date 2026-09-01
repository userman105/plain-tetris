import 'package:flutter/material.dart';
class Palette {
  Palette._();

  static const Color background = Color(0xFFF5F0E1);

  static const Color blockFill = Color(0xFF1B3B2F);

  static const Color gridLine = Color(0xFFDCD3B8);

  static const Color blockOutline = Color(0xFF0F241C);

  static const Color textPrimary = Color(0xFF1B3B2F);

  static const Color buttonSurface = Color(0xFFE6DFC8);
  static const Color buttonSurfacePressed = Color(0xFFD8CFAE);
  static Color controlOverlay = blockFill.withValues(alpha :0.12);
  static Color controlOverlayPressed = blockFill.withValues(alpha :0.22);
  static Color controlIcon = blockFill.withValues(alpha :0.75);
  static Color statsPanelBackground = background.withValues(alpha : 0.92);
}
