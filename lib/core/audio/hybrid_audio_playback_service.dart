import 'dart:async';
import '../settings/app_settings_storage.dart';
import 'audio_playback_service.dart';
import 'tts_speech_service.dart';

class HybridAudioPlaybackService {
  final AudioPlaybackService _audioPlayer;
  final TtsSpeechService _tts;
  final AppSettingsStorage _settings;

  HybridAudioPlaybackService({
    required AudioPlaybackService audioPlayer,
    required TtsSpeechService tts,
    required AppSettingsStorage settings,
  })  : _audioPlayer = audioPlayer,
        _tts = tts,
        _settings = settings;

  Future<void> playAudioOrSpeak({
    String? audioPathOrUrl,
    required String fallbackText,
    PortugueseDialect? dialect,
    double? rate,
  }) async {
    await stop();

    if (audioPathOrUrl != null && audioPathOrUrl.trim().isNotEmpty) {
      try {
        if (audioPathOrUrl.startsWith('http://') || audioPathOrUrl.startsWith('https://')) {
          await _audioPlayer.playUrl(audioPathOrUrl);
          return;
        } else if (audioPathOrUrl.startsWith('assets/')) {
          await _audioPlayer.playAsset(audioPathOrUrl);
          return;
        }
      } catch (_) {
        // Fall back to TTS below
      }
    }

    final targetDialect = dialect ?? await _settings.getDialect();
    await _tts.speak(fallbackText, dialect: targetDialect, rate: rate);
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    await _tts.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
    _tts.dispose();
  }
}
