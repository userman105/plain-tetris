import 'dart:math';
import '../models/tetromino.dart';

class SpawnSystem {
  final Random _random;
  final List<TetrominoType> _bag = [];

  SpawnSystem({Random? random}) : _random = random ?? Random();

  TetrominoType next() {
    if (_bag.isEmpty) _refillBag();
    return _bag.removeLast();
  }

  void _refillBag() {
    _bag.addAll(TetrominoType.values);
    _bag.shuffle(_random);
  }
}
 