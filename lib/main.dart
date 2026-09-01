import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/palette.dart';
import 'widgets/game_screen.dart';

void main() {
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tetris',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Palette.background,
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme(),
      ),
      home: const GameScreen(),
    );
  }
}