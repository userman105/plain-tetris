import 'package:flutter/material.dart';
import '../logic/game_controller.dart';
import '../models/game_state.dart';
import '../theme/app_text.dart';
import '../theme/palette.dart';
import 'difficulty_bar.dart';
import 'game_board_widget.dart';
import 'next_piece_review.dart';

/// The single screen of the app, now driven by a real [GameController].
///
/// Layout philosophy unchanged from the mockup phase: the board fills
/// the entire viewport, every control floats on top of it at low
/// opacity, and score/timer/mute are hidden until pause is tapped.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GameController()..start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePause() {
    if (_controller.state.status == GameStatus.paused) {
      _controller.resume();
    } else {
      _controller.pause();
    }
  }

  String _formatElapsed(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final state = _controller.state;
          final isPaused = state.status == GameStatus.paused;
          final isGameOver = state.status == GameStatus.gameOver;

          return Stack(
            children: [
              // --- Fullscreen board ---
              Positioned.fill(child: GameBoardWidget(controller: _controller)),

              // --- Difficulty bar, thin strip along the very top ---
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                child: DifficultyBar(
                  level: state.level,
                  maxLevel: GameController.maxLevel,
                ),
              ),

              // --- Next piece preview, top-left, always visible ---
              Positioned(
                top: MediaQuery.of(context).padding.top + 24,
                left: 12,
                child: NextPiecePreview(type: _controller.nextType),
              ),

              // --- Score / timer / mute panel, revealed by pause ---
              Positioned(
                top: MediaQuery.of(context).padding.top + 56,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedSlide(
                    offset: isPaused ? Offset.zero : const Offset(0, -0.3),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: AnimatedOpacity(
                      opacity: isPaused ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: IgnorePointer(
                        ignoring: !isPaused,
                        child: _StatsPanel(
                          score: state.score,
                          elapsedLabel: _formatElapsed(state.elapsed),
                          isMuted: state.isMuted,
                          onToggleMute: _controller.toggleMute,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // --- Game over message ---
              if (isGameOver)
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Palette.statsPanelBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Game Over', style: AppText.heading),
                          const SizedBox(height: 12),
                          Text('Score: ${state.score}', style: AppText.stat),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: _controller.start,
                            child: Text('Play Again', style: AppText.button),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // --- Pause button, top-right, always visible ---
              Positioned(
                top: MediaQuery.of(context).padding.top + 24,
                right: 12,
                child: _FloatingIconButton(
                  icon: isPaused ? Icons.play_arrow : Icons.pause,
                  onPressed: isGameOver ? null : _togglePause,
                ),
              ),

              // --- Movement controls, bottom, always visible & transparent ---
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).padding.bottom + 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _FloatingIconButton(
                      icon: Icons.arrow_back,
                      onPressed: isGameOver ? null : _controller.moveLeft,
                    ),
                    _FloatingIconButton(
                      icon: Icons.rotate_right,
                      onPressed: isGameOver ? null : _controller.rotate,
                    ),
                    _FloatingIconButton(
                      icon: Icons.arrow_forward,
                      onPressed: isGameOver ? null : _controller.moveRight,
                    ),
                    _FloatingIconButton(
                      icon: Icons.arrow_downward,
                      onPressed: isGameOver ? null : _controller.hardDrop,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A round, low-opacity button that sits directly on top of the
/// board without introducing a solid UI surface. A null [onPressed]
/// renders it visibly disabled (e.g. once the game is over).
class _FloatingIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _FloatingIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return Material(
      color: Palette.controlOverlay,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        highlightColor: Palette.controlOverlayPressed,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(
            icon,
            color: disabled ? Palette.controlIcon.withValues(alpha: 0.3) : Palette.controlIcon,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  final int score;
  final String elapsedLabel;
  final bool isMuted;
  final VoidCallback onToggleMute;

  const _StatsPanel({
    required this.score,
    required this.elapsedLabel,
    required this.isMuted,
    required this.onToggleMute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Palette.statsPanelBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Palette.blockFill.withValues(alpha : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _statText('Score: $score'),
          const SizedBox(height: 10),
          _statText('Time: $elapsedLabel'),
          const SizedBox(height: 14),
          InkWell(
            onTap: onToggleMute,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                isMuted ? Icons.volume_off : Icons.volume_up,
                color: Palette.textPrimary,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statText(String text) {
    return Text(text, style: AppText.stat);
  }
}