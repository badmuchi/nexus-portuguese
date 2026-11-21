import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../../srs/data/repositories/srs_repository_impl.dart';
import '../../../srs/domain/entities/srs_card_entity.dart';
import '../../domain/entities/portuguese_life_scene.dart';
import '../../domain/repositories/scenes_repository.dart';
import 'scenes_state.dart';

class ScenesCubit extends Cubit<ScenesState> {
  final ScenesRepository repository;
  final HybridAudioPlaybackService audioService;
  final SrsRepository srsRepository;

  ScenesCubit({
    required this.repository,
    required this.audioService,
    required this.srsRepository,
  }) : super(const ScenesLoading());

  Future<void> loadScenes() async {
    emit(const ScenesLoading());

    final scenesResult = await repository.getScenes();
    final progressResult = await repository.getAllProgress();

    if (scenesResult.isOk) {
      emit(ScenesLoaded(
        scenes: scenesResult.value,
        progressMap: progressResult.isOk ? progressResult.value : const {},
      ));
    } else {
      emit(ScenesError(scenesResult.failure?.message ?? 'Ошибка загрузки сцен'));
    }
  }

  void filterCategory(SceneCategory? category) {
    final current = state;
    if (current is ScenesLoaded) {
      emit(current.copyWith(selectedCategory: () => category));
    }
  }

  Future<void> playAudio(String text, {String? dialectTag}) async {
    final current = state;
    if (current is ScenesLoaded) {
      emit(current.copyWith(activePlayingText: () => text));
    }

    try {
      final dialect = dialectTag == 'pt-PT'
          ? PortugueseDialect.european
          : PortugueseDialect.brazilian;

      await audioService.playAudioOrSpeak(
        fallbackText: text,
        dialect: dialect,
      );
    } finally {
      if (state is ScenesLoaded) {
        emit((state as ScenesLoaded).copyWith(activePlayingText: () => null));
      }
    }
  }

  Future<void> recordChallengeCompleted({
    required String sceneId,
    required int completedCount,
    required int totalCount,
  }) async {
    final isDone = completedCount >= totalCount;
    await repository.saveSceneProgress(
      sceneId: sceneId,
      completedCount: completedCount,
      totalCount: totalCount,
      isCompleted: isDone,
    );

    // Refresh progress in state
    final progressResult = await repository.getAllProgress();
    if (progressResult.isOk && state is ScenesLoaded) {
      emit((state as ScenesLoaded).copyWith(progressMap: progressResult.value));
    }
  }

  Future<bool> addWordToSrs(SceneWord word) async {
    try {
      final srsCard = SrsCardEntity(
        id: 'srs_scene_${word.id}',
        portuguese: word.portuguese,
        russianTranslation: word.russianMeaning,
        partOfSpeech: word.gender != null ? 'substantivo (${word.gender})' : 'palavra',
        category: 'cenas_da_vida',
        dialect: word.dialectTag,
        notes: word.contextNote,
        fsrsState: 'newCard',
        stability: 0.0,
        difficulty: 0.0,
        reps: 0,
        lapses: 0,
        dueAt: DateTime.now(),
      );

      await srsRepository.addCard(srsCard);
      return true;
    } catch (_) {
      return false;
    }
  }
}
