import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import '../logging/app_logger.dart';
import '../settings/app_settings_storage.dart';

class TtsSpeechService {
  final FlutterTts _flutterTts;
  final AppLogger _logger = const AppLogger('TtsSpeechService');
  final AppSettingsStorage _settings;

  final _isSpeakingController = StreamController<bool>.broadcast();
  Stream<bool> get isSpeakingStream => _isSpeakingController.stream;

  TtsSpeechService({
    FlutterTts? flutterTts,
    required AppSettingsStorage settings,
  })  : _flutterTts = flutterTts ?? FlutterTts(),
        _settings = settings {
    _initTts();
  }

  void _initTts() {
    _flutterTts.setStartHandler(() {
      _isSpeakingController.add(true);
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeakingController.add(false);
    });

    _flutterTts.setErrorHandler((dynamic msg) {
      _logger.warning('TTS Error: $msg');
      _isSpeakingController.add(false);
    });
  }

  Future<void> speak(
    String text, {
    PortugueseDialect? dialect,
    double? rate,
  }) async {
    try {
      final targetDialect = dialect ?? await _settings.getDialect();
      final targetRate = rate ?? await _settings.getTtsRate();

      await _flutterTts.setLanguage(targetDialect.ttsLocale);
      await _flutterTts.setSpeechRate(targetRate);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak(text);
    } catch (e, st) {
      _logger.warning('Failed to speak with TTS: $text', e, st);
      _isSpeakingController.add(false);
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _isSpeakingController.add(false);
    } catch (_) {}
  }

  void dispose() {
    _isSpeakingController.close();
  }
}
