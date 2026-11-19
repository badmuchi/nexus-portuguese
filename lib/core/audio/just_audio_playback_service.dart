import 'package:just_audio/just_audio.dart';
import '../logging/app_logger.dart';
import 'audio_playback_service.dart';

class JustAudioPlaybackService implements AudioPlaybackService {
  final AudioPlayer _player;
  final AppLogger _logger = const AppLogger('JustAudioPlaybackService');

  JustAudioPlaybackService({AudioPlayer? player})
      : _player = player ?? AudioPlayer();

  @override
  Stream<bool> get isPlayingStream => _player.playingStream;

  @override
  Future<void> playAsset(String assetPath) async {
    try {
      await _player.stop();
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e, st) {
      _logger.warning('Failed to play asset audio: $assetPath', e, st);
    }
  }

  @override
  Future<void> playUrl(String url) async {
    try {
      await _player.stop();
      await _player.setUrl(url);
      await _player.play();
    } catch (e, st) {
      _logger.warning('Failed to play URL audio: $url', e, st);
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> resume() async {
    await _player.play();
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
  }
}
