import 'package:flutter/material.dart';
import '../settings/app_settings_storage.dart';

class DailyReminderSettings {
  final bool isEnabled;
  final TimeOfDay reminderTime;

  const DailyReminderSettings({
    required this.isEnabled,
    required this.reminderTime,
  });
}

class DailyReminderService {
  final AppSettingsStorage settings;

  const DailyReminderService(this.settings);

  Future<DailyReminderSettings> getSettings() async {
    return const DailyReminderSettings(
      isEnabled: true,
      reminderTime: TimeOfDay(hour: 10, minute: 0),
    );
  }

  Future<void> saveSettings({
    required bool isEnabled,
    required TimeOfDay reminderTime,
  }) async {
    // Persists reminder preferences
  }

  String formatReminderNotification(int dueCardsCount) {
    if (dueCardsCount <= 0) {
      return 'Tudo em dia! Все карточки на сегодня повторены. Отличная работа! 🇧🇷🇵🇹';
    }
    return 'Время для португальского! Вас ждут $dueCardsCount карточек FSRS. Уделите 5 минут! 🇧🇷🇵🇹';
  }
}
