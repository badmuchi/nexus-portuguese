import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/settings/app_settings_storage.dart';
import 'package:nexus_portuguese_app/features/srs/data/repositories/srs_repository_impl.dart';
import 'package:nexus_portuguese_app/features/assessment/presentation/cubit/assessment_cubit.dart';
import 'package:nexus_portuguese_app/features/assessment/presentation/cubit/assessment_state.dart';
import 'package:nexus_portuguese_app/features/assessment/presentation/screens/level_assessment_screen.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/presentation/screens/verb_trainer_screen.dart';
import 'package:nexus_portuguese_app/features/sentence_builder/presentation/screens/sentence_builder_screen.dart';
import 'package:nexus_portuguese_app/features/phonetics/presentation/screens/phonetics_screen.dart';
import 'package:nexus_portuguese_app/features/scenes/presentation/screens/scenes_catalog_screen.dart';
import 'package:nexus_portuguese_app/features/slang/presentation/screens/slang_screen.dart';
import 'package:nexus_portuguese_app/features/speech_lab/presentation/screens/speech_lab_screen.dart';
import 'package:nexus_portuguese_app/features/stories/presentation/screens/stories_screen.dart';
import 'package:nexus_portuguese_app/features/auditorio/presentation/screens/auditorio_catalog_screen.dart';
import 'package:nexus_portuguese_app/features/diary/presentation/screens/diary_catalog_screen.dart';
import 'package:nexus_portuguese_app/features/duels/presentation/screens/duels_lobby_screen.dart';
import 'package:nexus_portuguese_app/features/idioms/presentation/screens/idioms_catalog_screen.dart';
import 'package:nexus_portuguese_app/features/music_lab/presentation/screens/music_catalog_screen.dart';
import 'package:nexus_portuguese_app/features/chat_simulator/presentation/screens/chat_catalog_screen.dart';
import 'package:nexus_portuguese_app/core/notifications/daily_reminder_service.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int tabIndex) onNavigateToTab;

  const HomeScreen({super.key, required this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PortugueseDialect _currentDialect = PortugueseDialect.brazilian;
  int _dueCardsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final settings = context.read<AppSettingsStorage>();
    final srsRepo = context.read<SrsRepository>();
    final dialect = await settings.getDialect();
    final due = await srsRepo.getDueCards();

    if (mounted) {
      setState(() {
        _currentDialect = dialect;
        _dueCardsCount = due.length;
      });
    }
  }

  void _changeDialect(PortugueseDialect dialect) {
    context.read<AppSettingsStorage>().setDialect(dialect);
    setState(() => _currentDialect = dialect);
  }

  void _showReminderSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notifications_active_rounded, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Ежедневные напоминания',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Регулярные 10 минут в день дают в 5 раз лучший результат, чем часовые штурмы раз в неделю.',
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.alarm_rounded),
                title: const Text('Время напоминания'),
                subtitle: const Text('Каждый день в 10:00 утра'),
                trailing: TextButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(ctx);
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 10, minute: 0),
                    );
                    if (picked != null) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('Напоминание установлено на ${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      navigator.pop();
                    }
                  },
                  child: const Text('Изменить'),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        DailyReminderService(context.read<AppSettingsStorage>())
                            .formatReminderNotification(_dueCardsCount),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audio = context.read<HybridAudioPlaybackService>();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_stories_rounded, color: Colors.amber),
            SizedBox(width: 8),
            Text('Nexus Portuguese', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Напоминания',
            onPressed: _showReminderSettings,
          ),
          PopupMenuButton<PortugueseDialect>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_currentDialect == PortugueseDialect.brazilian ? '🇧🇷 PT-BR' : '🇵🇹 PT-PT'),
                  const Icon(Icons.arrow_drop_down, size: 18),
                ],
              ),
            ),
            tooltip: 'Сменить диалект',
            onSelected: _changeDialect,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: PortugueseDialect.brazilian,
                child: Row(
                  children: [
                    Text('🇧🇷'),
                    SizedBox(width: 8),
                    Text('Бразильский (PT-BR)'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: PortugueseDialect.european,
                child: Row(
                  children: [
                    Text('🇵🇹'),
                    SizedBox(width: 8),
                    Text('Европейский (PT-PT)'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Word of the Day (Palavra do Dia)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.surfaceContainerHighest,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'PALAVRA DO DIA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded),
                        color: theme.colorScheme.primary,
                        onPressed: () {
                          audio.playAudioOrSpeak(fallbackText: 'Saudade. Estou com muita saudade.');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Saudade',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Светлая тоска, ностальгия, скучание по тому, кого любишь',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '«Estou com muita saudade do Brasil.»',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Due Cards Reminder Banner
            if (_dueCardsCount > 0)
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => widget.onNavigateToTab(2), // Tab index 2 is FSRS
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber.shade700),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.alarm_on_rounded, color: Colors.amber, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_dueCardsCount карточек ждут повторения',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text('Повторите их сейчас, чтобы закрепить в памяти!'),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // CEFR Diagnostic Banner
            BlocBuilder<AssessmentCubit, AssessmentState>(
              builder: (context, assessmentState) {
                String bannerTitle = 'Пройдите диагностику CEFR';
                String bannerSubtitle = 'Определите свой уровень (A1–B2) и получите сертификат';
                String? levelBadge;

                if (assessmentState is AssessmentCompleted) {
                  levelBadge = assessmentState.result.level.label;
                  bannerTitle = 'Ваш уровень: ${assessmentState.result.levelTitleRu}';
                  bannerSubtitle = 'Точность: ${assessmentState.result.scorePercentage.round()}% • Нажмите для просмотра сертификата';
                }

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LevelAssessmentScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.withValues(alpha: 0.15),
                          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: levelBadge != null
                                ? Text(
                                    levelBadge,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  )
                                : const Icon(Icons.workspace_premium_rounded, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bannerTitle,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                bannerSubtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            Text(
              'Разделы приложения:',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Grid of Modules
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                _buildModuleCard(
                  theme,
                  title: 'Диалоги',
                  subtitle: 'Кафе, пляж, такси',
                  icon: Icons.forum_rounded,
                  color: Colors.teal,
                  onTap: () => widget.onNavigateToTab(1),
                ),
                _buildModuleCard(
                  theme,
                  title: 'FSRS Карточки',
                  subtitle: 'Интервальные повторы',
                  icon: Icons.style_rounded,
                  color: Colors.blue,
                  onTap: () => widget.onNavigateToTab(2),
                ),
                _buildModuleCard(
                  theme,
                  title: 'Грамматика',
                  subtitle: 'Спряжения, do/no/à',
                  icon: Icons.table_chart_rounded,
                  color: Colors.indigo,
                  onTap: () => widget.onNavigateToTab(3),
                ),
                _buildModuleCard(
                  theme,
                  title: 'Аудирование',
                  subtitle: 'Диктанты и слух',
                  icon: Icons.headphones_rounded,
                  color: Colors.purple,
                  onTap: () => widget.onNavigateToTab(4),
                ),
                _buildModuleCard(
                  theme,
                  title: 'Лаборатория речи',
                  subtitle: 'Акустика и дикция',
                  icon: Icons.mic_external_on_rounded,
                  color: Colors.pink.shade700,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SpeechLabScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'Словарь',
                  subtitle: 'Оффлайн поиск слов',
                  icon: Icons.menu_book_rounded,
                  color: Colors.green,
                  onTap: () => widget.onNavigateToTab(5),
                ),
                _buildModuleCard(
                  theme,
                  title: 'Фонетика',
                  subtitle: 'Носовые звуки ão/õe',
                  icon: Icons.graphic_eq_rounded,
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PhoneticsScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'Истории',
                  subtitle: 'Интерактивные тексты',
                  icon: Icons.auto_stories_rounded,
                  color: Colors.brown,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StoriesScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'Сленг и идиомы',
                  subtitle: 'Gírias: Legal vs Fixe',
                  icon: Icons.emoji_emotions_rounded,
                  color: Colors.amber.shade900,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SlangScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'Сцены жизни',
                  subtitle: 'Кафе, пляж, метро',
                  icon: Icons.theater_comedy_rounded,
                  color: Colors.teal.shade800,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScenesCatalogScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'Тест CEFR',
                  subtitle: 'Уровень A1–B2',
                  icon: Icons.workspace_premium_rounded,
                  color: Colors.deepPurple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LevelAssessmentScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'VerboSprint',
                  subtitle: 'Спринт спряжений ⚡️',
                  icon: Icons.bolt_rounded,
                  color: Colors.amber.shade900,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VerbTrainerScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'Конструктор фраз',
                  subtitle: 'Синтаксис и порядок 🧩',
                  icon: Icons.extension_rounded,
                  color: Colors.teal.shade700,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SentenceBuilderScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'Центр беглости',
                  subtitle: 'Стрик и 12 наград 🏆',
                  icon: Icons.military_tech_rounded,
                  color: Colors.amber.shade800,
                  onTap: () => widget.onNavigateToTab(6),
                ),
                _buildModuleCard(
                  theme,
                  title: 'Auditório',
                  subtitle: 'Подкасты & Shadowing 🎙️',
                  icon: Icons.podcasts_rounded,
                  color: Colors.deepPurple.shade700,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AuditorioCatalogScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'Бортовой дневник',
                  subtitle: 'Письмо & AI-тьютор 📖',
                  icon: Icons.history_edu_rounded,
                  color: Colors.indigo.shade700,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DiaryCatalogScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'Арена дуэлей',
                  subtitle: 'PT-BR vs PT-PT ⚔️',
                  icon: Icons.sports_kabaddi_rounded,
                  color: Colors.deepOrange.shade800,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DuelsLobbyScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'Идиомы',
                  subtitle: 'Образы и поговорки 🎨',
                  icon: Icons.palette_rounded,
                  color: Colors.teal.shade800,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const IdiomsCatalogScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'Караоке & Музыка',
                  subtitle: 'Босса-нова и фаду 🎶',
                  icon: Icons.music_note_rounded,
                  color: Colors.pink.shade800,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MusicCatalogScreen()),
                    );
                  },
                ),
                _buildModuleCard(
                  theme,
                  title: 'Симулятор чатов',
                  subtitle: 'WhatsApp & сленг 💬',
                  icon: Icons.chat_bubble_rounded,
                  color: Colors.green.shade800,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatCatalogScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Cultural Dialect Tip Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Знаете ли вы?',
                          style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'В Бразилии для обращения на "ты" обычно используют "você" (со спряжением 3-го лица: você fala), а в Португалии чаще говорят "tu" (со спряжением 2-го лица: tu falas).',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color, size: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
