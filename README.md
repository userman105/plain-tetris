# Tetris (Flutter)

Single-screen, monochrome Tetris. Beige background, dark green tetrominoes,
all shapes are Canvas-drawn via CustomPainter — no image assets.

## Getting started
1. Drop this folder into your Flutter workspace (or `flutter create .` first
   if you want Flutter to regenerate platform folders like android/ios).
2. `flutter pub get`
3. Add a looping background track to `assets/audio/` (referenced by
   AudioManager — filename TBD in a later step).
4. `flutter run`

## Structure
- `models/`   — pure data: Tetromino, Board, GameState
- `logic/`    — game rules: controller, collision, line clear, spawn system
- `painters/` — CustomPainter classes that draw the board & active piece
- `widgets/`  — UI: the single GameScreen, board widget, score panel, buttons
- `audio/`    — AudioManager wrapping `audioplayers`
- `theme/`    — Palette (beige/dark green color constants)

## Status
Project skeleton only. GameScreen renders a static placeholder layout.
Next steps: implement Tetromino shapes + rotation, Board collision logic,
then wire CustomPainters into the board widget.
