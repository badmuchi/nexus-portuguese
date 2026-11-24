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
import 'features/sentence_builder/data/repositories/sentence_builder_repository_impl.dart';
import 'features/sentence_builder/domain/repositories/sentence_builder_repository.dart';
import 'features/sentence_builder/presentation/cubit/sentence_builder_cubit.dart';
import 'features/auditorio/data/repositories/auditorio_repository_impl.dart';
import 'features/auditorio/domain/repositories/auditorio_repository.dart';
import 'features/diary/data/repositories/diary_repository_impl.dart';
import 'features/diary/domain/repositories/diary_repository.dart';
import 'features/duels/data/repositories/duels_repository_impl.dart';
import 'features/duels/domain/repositories/duels_repository.dart';
import 'features/idioms/data/repositories/idioms_repository_impl.dart';
import 'features/idioms/domain/repositories/idioms_repository.dart';
import 'features/music_lab/data/repositories/music_repository_impl.dart';
import 'features/music_lab/domain/repositories/music_repository.dart';
import 'features/chat_simulator/data/repositories/chat_simulator_repository_impl.dart';
import 'features/chat_simulator/domain/repositories/chat_simulator_repository.dart';
import 'features/survival_guide/data/repositories/survival_guide_repository_impl.dart';
import 'features/survival_guide/domain/repositories/survival_guide_repository.dart';
import 'features/career/data/repositories/career_repository_impl.dart';
import 'features/career/domain/repositories/career_repository.dart';
import 'features/gastronomy/data/repositories/gastronomy_repository_impl.dart';
import 'features/gastronomy/domain/repositories/gastronomy_repository.dart';
import 'features/cinema/data/repositories/cinema_repository_impl.dart';
import 'features/cinema/domain/repositories/cinema_repository.dart';
import 'features/travel_guide/data/repositories/travel_guide_repository_impl.dart';
import 'features/travel_guide/domain/repositories/travel_guide_repository.dart';
import 'features/literature/data/repositories/literature_repository_impl.dart';
import 'features/literature/domain/repositories/literature_repository.dart';
import 'features/football/data/repositories/football_repository_impl.dart';
import 'features/football/domain/repositories/football_repository.dart';
import 'features/radionovela/data/repositories/radio_novela_repository_impl.dart';
import 'features/radionovela/domain/repositories/radio_novela_repository.dart';
import 'features/bazar/data/repositories/bazar_repository_impl.dart';
import 'features/bazar/domain/repositories/bazar_repository.dart';
import 'features/humor/data/repositories/humor_repository_impl.dart';
import 'features/humor/domain/repositories/humor_repository.dart';
import 'features/nature/data/repositories/nature_repository_impl.dart';
import 'features/nature/domain/repositories/nature_repository.dart';
import 'features/art/data/repositories/art_repository_impl.dart';
import 'features/art/domain/repositories/art_repository.dart';
import 'features/architecture/data/repositories/architecture_repository_impl.dart';
import 'features/architecture/domain/repositories/architecture_repository.dart';
import 'features/festas/data/repositories/festas_repository_impl.dart';
import 'features/festas/domain/repositories/festas_repository.dart';
import 'features/finance/data/repositories/finance_repository_impl.dart';
import 'features/finance/domain/repositories/finance_repository.dart';
import 'features/folklore/data/repositories/folklore_repository_impl.dart';
import 'features/folklore/domain/repositories/folklore_repository.dart';
import 'features/science/data/repositories/science_repository_impl.dart';
import 'features/science/domain/repositories/science_repository.dart';
import 'features/fashion/data/repositories/fashion_repository_impl.dart';
import 'features/fashion/domain/repositories/fashion_repository.dart';
import 'features/wine/data/repositories/wine_repository_impl.dart';
import 'features/wine/domain/repositories/wine_repository.dart';
import 'features/ancestral/data/repositories/ancestral_repository_impl.dart';
import 'features/ancestral/domain/repositories/ancestral_repository.dart';
import 'features/carnival/data/repositories/carnival_repository_impl.dart';
import 'features/carnival/domain/repositories/carnival_repository.dart';
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
  const sentenceBuilderRepository = SentenceBuilderRepositoryImpl();
  final auditorioRepository = AuditorioRepositoryImpl(database: database);
  final diaryRepository = DiaryRepositoryImpl(database: database);
  final duelsRepository = DuelsRepositoryImpl(database: database);
  final idiomsRepository = IdiomsRepositoryImpl(database: database);
  final musicRepository = MusicRepositoryImpl(database: database);
  final chatSimulatorRepository = ChatSimulatorRepositoryImpl(database: database);
  final survivalGuideRepository = SurvivalGuideRepositoryImpl(database: database);
  final careerRepository = CareerRepositoryImpl(database: database);
  final gastronomyRepository = GastronomyRepositoryImpl(database: database);
  final cinemaRepository = CinemaRepositoryImpl(database: database);
  final travelGuideRepository = TravelGuideRepositoryImpl(database: database);
  final literatureRepository = LiteratureRepositoryImpl(database: database);
  final footballRepository = FootballRepositoryImpl(database: database);
  final radioNovelaRepository = RadioNovelaRepositoryImpl(database: database);
  final bazarRepository = BazarRepositoryImpl(database: database);
  final humorRepository = HumorRepositoryImpl(
    database: database,
    srsRepository: srsRepository,
  );
  final natureRepository = NatureRepositoryImpl(
    database: database,
    srsRepository: srsRepository,
  );
  final artRepository = ArtRepositoryImpl(
    database: database,
    srsRepository: srsRepository,
  );
  final architectureRepository = ArchitectureRepositoryImpl(
    database: database,
    srsRepository: srsRepository,
  );
  final festasRepository = FestasRepositoryImpl(
    database: database,
    srsRepository: srsRepository,
  );
  final financeRepository = FinanceRepositoryImpl(
    database: database,
    srsRepository: srsRepository,
  );
  final folkloreRepository = FolkloreRepositoryImpl(
    database: database,
    srsRepository: srsRepository,
  );
  final scienceRepository = ScienceRepositoryImpl(
    database: database,
    srsRepository: srsRepository,
  );
  final fashionRepository = FashionRepositoryImpl(
    database: database,
    srsRepository: srsRepository,
  );
  final wineRepository = WineRepositoryImpl(
    database: database,
    srsRepository: srsRepository,
  );
  final ancestralRepository = AncestralRepositoryImpl(
    database: database,
    srsRepository: srsRepository,
  );
  final carnivalRepository = CarnivalRepositoryImpl(
    database: database,
    srsRepository: srsRepository,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppSettingsStorage>.value(value: settingsStorage),
        RepositoryProvider<AppDatabase>.value(value: database),
        RepositoryProvider<HybridAudioPlaybackService>.value(value: hybridAudio),
        RepositoryProvider<SpeechRecognitionService>.value(value: speechService),
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
        RepositoryProvider<SentenceBuilderRepository>.value(value: sentenceBuilderRepository),
        RepositoryProvider<AuditorioRepository>.value(value: auditorioRepository),
        RepositoryProvider<DiaryRepository>.value(value: diaryRepository),
        RepositoryProvider<DuelsRepository>.value(value: duelsRepository),
        RepositoryProvider<IdiomsRepository>.value(value: idiomsRepository),
        RepositoryProvider<MusicRepository>.value(value: musicRepository),
        RepositoryProvider<ChatSimulatorRepository>.value(value: chatSimulatorRepository),
        RepositoryProvider<SurvivalGuideRepository>.value(value: survivalGuideRepository),
        RepositoryProvider<CareerRepository>.value(value: careerRepository),
        RepositoryProvider<GastronomyRepository>.value(value: gastronomyRepository),
        RepositoryProvider<CinemaRepository>.value(value: cinemaRepository),
        RepositoryProvider<TravelGuideRepository>.value(value: travelGuideRepository),
        RepositoryProvider<LiteratureRepository>.value(value: literatureRepository),
        RepositoryProvider<FootballRepository>.value(value: footballRepository),
        RepositoryProvider<RadioNovelaRepository>.value(value: radioNovelaRepository),
        RepositoryProvider<BazarRepository>.value(value: bazarRepository),
        RepositoryProvider<HumorRepository>.value(value: humorRepository),
        RepositoryProvider<NatureRepository>.value(value: natureRepository),
        RepositoryProvider<ArtRepository>.value(value: artRepository),
        RepositoryProvider<ArchitectureRepository>.value(value: architectureRepository),
        RepositoryProvider<FestasRepository>.value(value: festasRepository),
        RepositoryProvider<FinanceRepository>.value(value: financeRepository),
        RepositoryProvider<FolkloreRepository>.value(value: folkloreRepository),
        RepositoryProvider<ScienceRepository>.value(value: scienceRepository),
        RepositoryProvider<FashionRepository>.value(value: fashionRepository),
        RepositoryProvider<WineRepository>.value(value: wineRepository),
        RepositoryProvider<AncestralRepository>.value(value: ancestralRepository),
        RepositoryProvider<CarnivalRepository>.value(value: carnivalRepository),
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
          BlocProvider<SentenceBuilderCubit>(
            create: (_) => SentenceBuilderCubit(
              repository: sentenceBuilderRepository,
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

  ThemeData _buildTheme(Brightness brightness) {
    const brandPrimary = Color(0xFF006C50);
    const brandSecondary = Color(0xFFD49B0E);

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandPrimary,
        secondary: brandSecondary,
        brightness: brightness,
      ),
    );

    final baseText = base.textTheme;
    final customTextTheme = baseText.copyWith(
      displayLarge: baseText.displayLarge?.copyWith(fontFamily: 'Fraunces', fontWeight: FontWeight.w700, letterSpacing: -0.5),
      displayMedium: baseText.displayMedium?.copyWith(fontFamily: 'Fraunces', fontWeight: FontWeight.w700, letterSpacing: -0.4),
      displaySmall: baseText.displaySmall?.copyWith(fontFamily: 'Fraunces', fontWeight: FontWeight.w700, letterSpacing: -0.3),
      headlineLarge: baseText.headlineLarge?.copyWith(fontFamily: 'Fraunces', fontWeight: FontWeight.w700, letterSpacing: -0.3),
      headlineMedium: baseText.headlineMedium?.copyWith(fontFamily: 'Fraunces', fontWeight: FontWeight.w700, letterSpacing: -0.2),
      headlineSmall: baseText.headlineSmall?.copyWith(fontFamily: 'Fraunces', fontWeight: FontWeight.w600),
      titleLarge: baseText.titleLarge?.copyWith(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w700, letterSpacing: -0.1),
      titleMedium: baseText.titleMedium?.copyWith(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600),
      titleSmall: baseText.titleSmall?.copyWith(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600),
      bodyLarge: baseText.bodyLarge?.copyWith(fontFamily: 'Inter', height: 1.45),
      bodyMedium: baseText.bodyMedium?.copyWith(fontFamily: 'Inter', height: 1.4),
      bodySmall: baseText.bodySmall?.copyWith(fontFamily: 'Inter', height: 1.35),
      labelLarge: baseText.labelLarge?.copyWith(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, letterSpacing: 0.2),
      labelMedium: baseText.labelMedium?.copyWith(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600),
      labelSmall: baseText.labelSmall?.copyWith(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500),
    );

    return base.copyWith(
      textTheme: customTextTheme,
      primaryTextTheme: customTextTheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus Portuguese',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
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
