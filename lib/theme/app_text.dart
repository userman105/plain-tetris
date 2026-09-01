import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'palette.dart';

class AppText {
  AppText._();

  static TextStyle stat = GoogleFonts.pressStart2p(
    color: Palette.textPrimary,
    fontSize: 10,
    height: 1.4,
  );

  static TextStyle heading = GoogleFonts.pressStart2p(
    color: Palette.textPrimary,
    fontSize: 14,
    height: 1.4,
  );

  static TextStyle button = GoogleFonts.pressStart2p(
    color: Palette.textPrimary,
    fontSize: 10,
    height: 1.4,
  );
}