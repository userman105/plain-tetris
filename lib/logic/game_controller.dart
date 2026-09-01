import 'dart:async';
import 'package:flutter/foundation.dart';

import '../audio/audio_manager.dart';
import '../models/board.dart';
import '../models/game_state.dart';
import '../models/tetromino.dart';
import 'collision_checker.dart';
import 'line_clear.dart';
import 'spawn_system.dart';
class GameController extends ChangeNotifier {
  Board board = Board();
  GameState state = const GameState();
  Tetromino? currentPiece;
  Tetromino? get ghostPiece {
    final piece = currentPiece;
    if (piece == null) return null;
    var ghost = piece;
    while (CollisionChecker.canMoveDown(ghost, board)) {
      ghost = ghost.moved(deltaRow: 1);
    }
    return ghost;
  }
  TetrominoType? nextType;

  final SpawnSystem _spawnSystem = SpawnSystem();
  final AudioManager _audioManager = AudioManager();

  Timer? _fallTimer;
  Timer? _clockTimer;

  static const int maxLevel = 15;
  static const int _levelDurationSeconds = 20;
  static const int _baseFallMs = 800;
  static const int _msPerLevel = 40;
  static const int _minFallMs = 200;

  Duration _fallIntervalForLevel(int level) {
    final ms = (_baseFallMs - level * _msPerLevel).clamp(_minFallMs, _baseFallMs);
    return Duration(milliseconds: ms);
  }
  double get difficultyProgress => (state.level / maxLevel).clamp(0.0, 1.0);

  void start() {
    final wasMuted = state.isMuted;
    board = Board();
    state = GameState(status: GameStatus.running, isMuted: wasMuted);
    nextType = _spawnSystem.next();
    currentPiece = Tetromino.spawn(nextType!, boardColumns: Board.columns);
    nextType = _spawnSystem.next(); // pre-fetch the following preview
    _startTimers();
    _audioManager.play();
    notifyListeners();
  }

  void pause() {
    if (state.status != GameStatus.running) return;
    _stopTimers();
    _audioManager.pause();
    state = state.copyWith(status: GameStatus.paused);
    notifyListeners();
  }

  void resume() {
    if (state.status != GameStatus.paused) return;
    state = state.copyWith(status: GameStatus.running);
    _startTimers();
    _audioManager.play();
    notifyListeners();
  }

  void toggleMute() {
    _audioManager.toggleMute();
    state = state.copyWith(isMuted: _audioManager.isMuted);
    notifyListeners();
  }

  void moveLeft() => _tryMove(deltaCol: -1);
  void moveRight() => _tryMove(deltaCol: 1);
  void softDrop() {
    if (state.status != GameStatus.running || currentPiece == null) return;
    if (CollisionChecker.canMoveDown(currentPiece!, board)) {
      currentPiece = currentPiece!.moved(deltaRow: 1);
      notifyListeners();
    } else {
      _lockPieceAndSpawnNext();
    }
  }

  void hardDrop() {
    if (state.status != GameStatus.running || currentPiece == null) return;
    currentPiece = ghostPiece;
    _lockPieceAndSpawnNext();
  }

  void rotate() {
    if (state.status != GameStatus.running || currentPiece == null) return;
    if (CollisionChecker.canRotateClockwise(currentPiece!, board)) {
      currentPiece = currentPiece!.rotatedClockwise();
      notifyListeners();
    }
  }

  void _tryMove({int deltaCol = 0}) {
    if (state.status != GameStatus.running || currentPiece == null) return;
    final moved = currentPiece!.moved(deltaCol: deltaCol);
    if (CollisionChecker.isValidPosition(moved, board)) {
      currentPiece = moved;
      notifyListeners();
    }
  }

  void _startTimers() {
    _fallTimer?.cancel();
    _clockTimer?.cancel();
    _fallTimer = Timer.periodic(_fallIntervalForLevel(state.level), (_) => _onFallTick());
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _onClockTick());
  }

  void _stopTimers() {
    _fallTimer?.cancel();
    _clockTimer?.cancel();
    _fallTimer = null;
    _clockTimer = null;
  }

  void _onFallTick() {
    if (currentPiece == null) return;
    if (CollisionChecker.canMoveDown(currentPiece!, board)) {
      currentPiece = currentPiece!.moved(deltaRow: 1);
      notifyListeners();
    } else {
      _lockPieceAndSpawnNext();
    }
  }

  void _onClockTick() {
    final newElapsed = state.elapsed + const Duration(seconds: 1);
    final newLevel = (newElapsed.inSeconds ~/ _levelDurationSeconds).clamp(0, maxLevel);
    final levelChanged = newLevel != state.level;

    state = state.copyWith(elapsed: newElapsed, level: newLevel);

    if (levelChanged) {
      _fallTimer?.cancel();
      _fallTimer = Timer.periodic(_fallIntervalForLevel(newLevel), (_) => _onFallTick());
    }

    notifyListeners();
  }

  void _lockPieceAndSpawnNext() {
    final piece = currentPiece;
    if (piece == null) return;

    for (final cell in piece.occupiedCells) {
      board.lock(cell.row, cell.col);
    }

    final result = LineClear.apply(board);
    state = state.copyWith(
      score: state.score + result.scoreDelta,
      linesCleared: state.linesCleared + result.linesCleared,
    );

    final spawnedType = nextType ?? _spawnSystem.next();
    final nextPiece = Tetromino.spawn(spawnedType, boardColumns: Board.columns);
    nextType = _spawnSystem.next(); // pre-fetch the following preview

    if (CollisionChecker.isGameOver(nextPiece, board)) {
      currentPiece = nextPiece;
      state = state.copyWith(status: GameStatus.gameOver);
      _stopTimers();
      _audioManager.pause();
      notifyListeners();
      return;
    }

    currentPiece = nextPiece;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTimers();
    _audioManager.dispose();
    super.dispose();
  }
}