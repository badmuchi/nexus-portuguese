import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum PortugueseDialect {
  brazilian('pt_BR', 'Бразильский (PT-BR)', 'pt-BR'),
  european('pt_PT', 'Европейский (PT-PT)', 'pt-PT');

  final String code;
  final String displayName;
  final String ttsLocale;

  const PortugueseDialect(this.code, this.displayName, this.ttsLocale);

  static PortugueseDialect fromCode(String? code) {
    if (code == 'pt_PT' || code == 'pt-PT') {
      return PortugueseDialect.european;
    }
    return PortugueseDialect.brazilian;
  }
}

class AppSettingsStorage {
  static const _keyDialect = 'nexus_portuguese_dialect';
  static const _keyTtsRate = 'nexus_portuguese_tts_rate';
  static const _keyThemeMode = 'nexus_portuguese_theme_mode';
  static const _keyAutoPlayAudio = 'nexus_portuguese_auto_play_audio';

  final FlutterSecureStorage _storage;

  AppSettingsStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final _dialectController = StreamController<PortugueseDialect>.broadcast();
  Stream<PortugueseDialect> get dialectStream => _dialectController.stream;

  Future<PortugueseDialect> getDialect() async {
    try {
      final val = await _storage.read(key: _keyDialect);
      return PortugueseDialect.fromCode(val);
    } catch (_) {
      return PortugueseDialect.brazilian;
    }
  }

  Future<void> setDialect(PortugueseDialect dialect) async {
    await _storage.write(key: _keyDialect, value: dialect.code);
    _dialectController.add(dialect);
  }

  Future<double> getTtsRate() async {
    try {
      final val = await _storage.read(key: _keyTtsRate);
      if (val != null) {
        return double.tryParse(val) ?? 0.5;
      }
    } catch (_) {}
    return 0.5;
  }

  Future<void> setTtsRate(double rate) async {
    await _storage.write(key: _keyTtsRate, value: rate.toString());
  }

  Future<ThemeMode> getThemeMode() async {
    try {
      final val = await _storage.read(key: _keyThemeMode);
      if (val == 'light') return ThemeMode.light;
      if (val == 'dark') return ThemeMode.dark;
    } catch (_) {}
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _storage.write(key: _keyThemeMode, value: mode.name);
  }

  Future<bool> getAutoPlayAudio() async {
    try {
      final val = await _storage.read(key: _keyAutoPlayAudio);
      if (val != null) return val == 'true';
    } catch (_) {}
    return true;
  }

  Future<void> setAutoPlayAudio(bool enabled) async {
    await _storage.write(key: _keyAutoPlayAudio, value: enabled.toString());
  }

  void dispose() {
    _dialectController.close();
  }
}
