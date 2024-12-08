// lib/services/audio_manager.dart

import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioManager._internal();

  Future<void> playBGM(String assetPath, {double volume = 0.5}) async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource(assetPath));
    await _audioPlayer.setVolume(volume);
  }

  Future<void> pauseBGM() async {
    await _audioPlayer.pause();
  }

  Future<void> resumeBGM() async {
    await _audioPlayer.resume();
  }

  Future<void> stopBGM() async {
    await _audioPlayer.stop();
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
