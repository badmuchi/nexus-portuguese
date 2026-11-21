import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/audio/hybrid_audio_playback_service.dart';
import 'core/audio/just_audio_playback_service.dart';
import 'core/audio/tts_speech_service.dart';
import 'core/database/app_database.dart';
import 'core/database/database_seed_service.dart';
import 'core/settings/app_settings_storage.dart';
import 'features/assessment/data/repositories/assessment_repository_impl.dart';
import 'features/assessment/domain/repositories/assessment_repository.dart';
import 'features/assessment/presentation/cubit/assessment_cubit.dart';
import 'features/verb_trainer/data/repositories/verb_trainer_repository_impl.dart';
import 'features/verb_trainer/domain/repositories/verb_trainer_repository.dart';
import 'features/verb_trainer/presentation/cubit/verb_trainer_cubit.dart';
import 'features/conversation/data/repositories/conversation_repository_impl.dart';
import 'features/conversation/presentation/cubit/conversation_cubit.dart';
import 'features/conversation/presentation/screens/conversation_screen.dart';
import 'features/dictionary/data/repositories/dictionary_repository_impl.dart';
import 'features/dictionary/presentation/cubit/dictionary_cubit.dart';
import 'features/dictionary/presentation/screens/dictionary_screen.dart';
import 'features/grammar/data/repositories/grammar_repository_impl.dart';
import 'features/grammar/presentation/cubit/grammar_cubit.dart';
import 'features/grammar/presentation/screens/grammar_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/listening/data/repositories/listening_repository_impl.dart';
import 'features/listening/presentation/cubit/listening_cubit.dart';
import 'features/listening/presentation/screens/listening_screen.dart';
import 'features/phonetics/data/repositories/phonetics_repository_impl.dart';
import 'features/phonetics/domain/repositories/phonetics_repository.dart';
import 'features/phonetics/presentation/cubit/phonetics_trainer_cubit.dart';
import 'features/progress/data/repositories/progress_repository_impl.dart';
import 'features/progress/domain/repositories/progress_repository.dart';
import 'features/progress/presentation/cubit/progress_cubit.dart';
import 'features/progress/presentation/screens/progress_screen.dart';
import 'features/scenes/data/repositories/scenes_repository_impl.dart';
import 'features/scenes/domain/repositories/scenes_repository.dart';
import 'features/scenes/presentation/cubit/scenes_cubit.dart';
import 'features/slang/data/repositories/slang_repository_impl.dart';
import 'features/slang/domain/repositories/slang_repository.dart';
import 'features/slang/presentation/cubit/slang_cubit.dart';
import 'features/stories/data/repositories/stories_repository_impl.dart';
import 'features/stories/domain/repositories/stories_repository.dart';
import 'features/stories/presentation/cubit/stories_cubit.dart';
import 'features/srs/data/repositories/srs_repository_impl.dart';
import 'features/srs/presentation/cubit/srs_cubit.dart';
import 'features/srs/presentation/screens/srs_screen.dart';
import 'core/speech/speech_recognition_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsStorage = AppSettingsStorage();
  final database = AppDatabase();
  final seedService = DatabaseSeedService(database);
  await seedService.seedIfEmpty();

  final audioPlayer = JustAudioPlaybackService();
  final ttsService = TtsSpeechService(settings: settingsStorage);
  final hybridAudio = HybridAudioPlaybackService(
    audioPlayer: audioPlayer,
    tts: ttsService,
    settings: settingsStorage,
  );

  final speechService = DefaultSpeechRecognitionService();
  final srsRepository = SrsRepositoryImpl(database);
  final conversationRepository = ConversationRepositoryImpl(database);
  final grammarRepository = GrammarRepositoryImpl(database);
  final listeningRepository = ListeningRepositoryImpl(database);
  final dictionaryRepository = DictionaryRepositoryImpl(database);
  final phoneticsRepository = PhoneticsRepositoryImpl(database: database);
  final progressRepository = ProgressRepositoryImpl(database);
  final slangRepository = SlangRepositoryImpl(database);
  final storiesRepository = StoriesRepositoryImpl(database);
  final scenesRepository = ScenesRepositoryImpl(database: database);
  final assessmentRepository = AssessmentRepositoryImpl(database: database);
  final verbTrainerRepository = VerbTrainerRepositoryImpl(database: database);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppSettingsStorage>.value(value: settingsStorage),
        RepositoryProvider<AppDatabase>.value(value: database),
        RepositoryProvider<HybridAudioPlaybackService>.value(value: hybridAudio),
        RepositoryProvider<SrsRepository>.value(value: srsRepository),
        RepositoryProvider<ConversationRepository>.value(value: conversationRepository),
        RepositoryProvider<GrammarRepository>.value(value: grammarRepository),
        RepositoryProvider<ListeningRepository>.value(value: listeningRepository),
        RepositoryProvider<DictionaryRepository>.value(value: dictionaryRepository),
        RepositoryProvider<PhoneticsRepository>.value(value: phoneticsRepository),
        RepositoryProvider<ProgressRepository>.value(value: progressRepository),
        RepositoryProvider<SlangRepository>.value(value: slangRepository),
        RepositoryProvider<StoriesRepository>.value(value: storiesRepository),
        RepositoryProvider<ScenesRepository>.value(value: scenesRepository),
        RepositoryProvider<AssessmentRepository>.value(value: assessmentRepository),
        RepositoryProvider<VerbTrainerRepository>.value(value: verbTrainerRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SrsCubit>(
            create: (_) => SrsCubit(
              repository: srsRepository,
              audioService: hybridAudio,
            ),
          ),
          BlocProvider<ConversationCubit>(
            create: (_) => ConversationCubit(
              repository: conversationRepository,
              audioService: hybridAudio,
              settings: settingsStorage,
            ),
          ),
          BlocProvider<GrammarCubit>(
            create: (_) => GrammarCubit(
              repository: grammarRepository,
              audioService: hybridAudio,
            ),
          ),
          BlocProvider<ListeningCubit>(
            create: (_) => ListeningCubit(
              repository: listeningRepository,
              audioService: hybridAudio,
            ),
          ),
          BlocProvider<DictionaryCubit>(
            create: (_) => DictionaryCubit(
              repository: dictionaryRepository,
              audioService: hybridAudio,
            ),
          ),
          BlocProvider<PhoneticsTrainerCubit>(
            create: (_) => PhoneticsTrainerCubit(
              repository: phoneticsRepository,
              audioService: hybridAudio,
              speechService: speechService,
            )..loadTrainer(),
          ),
          BlocProvider<ProgressCubit>(
            create: (_) => ProgressCubit(
              repository: progressRepository,
            ),
          ),
          BlocProvider<SlangCubit>(
            create: (_) => SlangCubit(
              repository: slangRepository,
            ),
          ),
          BlocProvider<StoriesCubit>(
            create: (_) => StoriesCubit(
              repository: storiesRepository,
            ),
          ),
          BlocProvider<ScenesCubit>(
            create: (_) => ScenesCubit(
              repository: scenesRepository,
              audioService: hybridAudio,
              srsRepository: srsRepository,
            )..loadScenes(),
          ),
          BlocProvider<AssessmentCubit>(
            create: (_) => AssessmentCubit(
              repository: assessmentRepository,
              audioService: hybridAudio,
              srsRepository: srsRepository,
            )..loadAssessment(),
          ),
          BlocProvider<VerbTrainerCubit>(
            create: (_) => VerbTrainerCubit(
              repository: verbTrainerRepository,
              audioService: hybridAudio,
              srsRepository: srsRepository,
            ),
          ),
        ],
        child: const NexusPortugueseApp(),
      ),
    ),
  );
}

class NexusPortugueseApp extends StatelessWidget {
  const NexusPortugueseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brandPrimary = Color(0xFF006C50); // Emerald Atlantic Green
    const brandSecondary = Color(0xFFD49B0E); // Sunny Warm Gold

    return MaterialApp(
      title: 'Nexus Portuguese',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandPrimary,
          secondary: brandSecondary,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandPrimary,
          secondary: brandSecondary,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onNavigateToTab: _onDestinationSelected),
      const ConversationScreen(),
      const SrsScreen(),
      const GrammarScreen(),
      const ListeningScreen(),
      const DictionaryScreen(),
      const ProgressScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 720.0;
        final body = IndexedStack(
          index: _selectedIndex,
          children: pages,
        );

        if (useRail) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: _onDestinationSelected,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Главная'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.forum_outlined),
                      selectedIcon: Icon(Icons.forum_rounded),
                      label: Text('Диалоги'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.style_outlined),
                      selectedIcon: Icon(Icons.style_rounded),
                      label: Text('FSRS'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.table_chart_outlined),
                      selectedIcon: Icon(Icons.table_chart_rounded),
                      label: Text('Грамматика'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.headphones_outlined),
                      selectedIcon: Icon(Icons.headphones_rounded),
                      label: Text('Слух'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book_rounded),
                      label: Text('Словарь'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.insights_outlined),
                      selectedIcon: Icon(Icons.insights_rounded),
                      label: Text('Прогресс'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: body),
              ],
            ),
          );
        }

        final baseTheme = Theme.of(context);
        final compactLabels = constraints.maxWidth < 450.0;

        return Scaffold(
          body: body,
          bottomNavigationBar: NavigationBarTheme(
            data: baseTheme.navigationBarTheme.copyWith(
              labelTextStyle: WidgetStatePropertyAll<TextStyle?>(
                baseTheme.textTheme.labelSmall?.copyWith(
                  fontSize: compactLabels ? 10.0 : 11.5,
                ),
              ),
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Главная',
                ),
                NavigationDestination(
                  icon: Icon(Icons.forum_outlined),
                  selectedIcon: Icon(Icons.forum_rounded),
                  label: 'Диалоги',
                ),
                NavigationDestination(
                  icon: Icon(Icons.style_outlined),
                  selectedIcon: Icon(Icons.style_rounded),
                  label: 'FSRS',
                ),
                NavigationDestination(
                  icon: Icon(Icons.table_chart_outlined),
                  selectedIcon: Icon(Icons.table_chart_rounded),
                  label: 'Грамматика',
                ),
                NavigationDestination(
                  icon: Icon(Icons.headphones_outlined),
                  selectedIcon: Icon(Icons.headphones_rounded),
                  label: 'Слух',
                ),
                NavigationDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book_rounded),
                  label: 'Словарь',
                ),
                NavigationDestination(
                  icon: Icon(Icons.insights_outlined),
                  selectedIcon: Icon(Icons.insights_rounded),
                  label: 'Прогресс',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
