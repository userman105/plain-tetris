enum GameStatus { idle, running, paused, gameOver }

class GameState {
  final int score;
  final Duration elapsed;
  final int linesCleared;
  final GameStatus status;
  final bool isMuted;

  final int level;

  const GameState({
    this.score = 0,
    this.elapsed = Duration.zero,
    this.linesCleared = 0,
    this.status = GameStatus.idle,
    this.isMuted = false,
    this.level = 0,
  });

  GameState copyWith({
    int? score,
    Duration? elapsed,
    int? linesCleared,
    GameStatus? status,
    bool? isMuted,
    int? level,
  }) {
    return GameState(
      score: score ?? this.score,
      elapsed: elapsed ?? this.elapsed,
      linesCleared: linesCleared ?? this.linesCleared,
      status: status ?? this.status,
      isMuted: isMuted ?? this.isMuted,
      level: level ?? this.level,
    );
  }
}