import 'package:audioplayers/audioplayers.dart';
class AudioManager {
  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;
  bool _isLoaded = false;

  static const String _bgMusicAsset = 'audio/bg_music.mp3';

  AudioManager() {
    _player.setReleaseMode(ReleaseMode.loop);
  }

  bool get isMuted => _isMuted;
  Future<void> play() async {
    if (!_isLoaded) {
      await _player.setSource(AssetSource(_bgMusicAsset));
      _isLoaded = true;
    }
    if (_isMuted) return;
    await _player.resume();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    if (_isMuted) {
      await _player.pause();
    } else if (_isLoaded) {
      await _player.resume();
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}