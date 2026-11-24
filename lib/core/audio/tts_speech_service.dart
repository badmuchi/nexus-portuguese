import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import '../logging/app_logger.dart';
import '../settings/app_settings_storage.dart';

class TtsSpeechService {
  final FlutterTts _flutterTts;
  final AppLogger _logger = const AppLogger('TtsSpeechService');
  final AppSettingsStorage _settings;
  final Map<String, Map<String, String>> _cachedBestVoices = {};

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


  static const List<String> _roboticVoiceBlacklist = [
    'eddy', 'flo', 'grandma', 'grandpa', 'reed', 'rocko',
    'sandy', 'shelley', 'zarvox', 'trinoids', 'whisper', 'bells',
    'boing', 'bubbles', 'cellos', 'bad news', 'good news', 'jester',
    'organ', 'superstar', 'wobble', 'compact',
  ];

  Future<void> _applyBestVoice(String targetLocale) async {
    if (_cachedBestVoices.containsKey(targetLocale)) {
      final cached = _cachedBestVoices[targetLocale]!;
      if (cached.isNotEmpty) {
        await _flutterTts.setVoice(cached);
      }
      return;
    }

    try {
      final rawVoices = await _flutterTts.getVoices;
      if (rawVoices is! List || rawVoices.isEmpty) {
        _cachedBestVoices[targetLocale] = const {};
        return;
      }

      final normalizedTarget = targetLocale.toLowerCase().replaceAll('_', '-');
      final preferredKeywords = normalizedTarget == 'pt-pt'
          ? ['raquel', 'duarte', 'joana', 'catarina', 'cristiano', 'neural', 'natural', 'premium', 'enhanced', 'google', 'microsoft']
          : ['francisca', 'antonio', 'thalita', 'google', 'microsoft', 'luciana', 'felipe', 'neural', 'natural', 'premium', 'enhanced'];

      Map<String, String>? bestVoice;
      int bestScore = -1000;

      for (final item in rawVoices) {
        if (item is! Map) continue;
        final name = item['name']?.toString() ?? '';
        final locale = item['locale']?.toString() ?? '';
        if (name.isEmpty || locale.isEmpty) continue;

        final normLocale = locale.toLowerCase().replaceAll('_', '-');
        if (!normLocale.startsWith('pt')) continue;

        final lowerName = name.toLowerCase();
        if (_roboticVoiceBlacklist.any(lowerName.contains)) continue;

        int score = 0;
        if (normLocale == normalizedTarget) {
          score += 50;
        } else if (normLocale.startsWith(normalizedTarget.split('-').first)) {
          score += 10;
        }

        for (int i = 0; i < preferredKeywords.length; i++) {
          if (lowerName.contains(preferredKeywords[i])) {
            score += (preferredKeywords.length - i) * 12;
          }
        }

        if (score > bestScore) {
          bestScore = score;
          bestVoice = {'name': name, 'locale': locale};
        }
      }

      _cachedBestVoices[targetLocale] = bestVoice ?? const {};
      if (bestVoice != null) {
        await _flutterTts.setVoice(bestVoice);
      }
    } catch (_) {
      _cachedBestVoices[targetLocale] = const {};
    }
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
      await _applyBestVoice(targetDialect.ttsLocale);
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
