import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/settings/app_settings_storage.dart';
import '../../data/repositories/conversation_repository_impl.dart';
import '../../domain/entities/dialogue_models.dart';
import 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final ConversationRepository _repository;
  final HybridAudioPlaybackService _audioService;
  final AppSettingsStorage _settings;

  ConversationCubit({
    required ConversationRepository repository,
    required HybridAudioPlaybackService audioService,
    required AppSettingsStorage settings,
  })  : _repository = repository,
        _audioService = audioService,
        _settings = settings,
        super(ConversationInitial());

  Future<void> initScenarios({String? startScenarioId}) async {
    emit(ConversationLoading());
    try {
      final scenarios = await _repository.getScenarios();
      if (scenarios.isEmpty) {
        emit(const ConversationError('Сценарии диалогов не найдены.'));
        return;
      }

      DialogueScenarioInfo active = scenarios.first;
      if (startScenarioId != null) {
        for (final s in scenarios) {
          if (s.id == startScenarioId) {
            active = s;
            break;
          }
        }
      }

      await loadScenario(active, scenarios: scenarios);
    } catch (e) {
      emit(ConversationError('Ошибка инициализации сценариев: $e'));
    }
  }

  Future<void> loadScenario(
    DialogueScenarioInfo scenario, {
    List<DialogueScenarioInfo>? scenarios,
  }) async {
    final allScenarios = scenarios ??
        (state is ConversationActive
            ? (state as ConversationActive).scenarios
            : await _repository.getScenarios());

    final startNode = await _repository.getNode(scenario.startNodeId);
    if (startNode == null) {
      emit(const ConversationError('Не удалось загрузить начальный узел сценария.'));
      return;
    }

    final initialHistory = [
      DialogueMessageItem(
        speaker: startNode.speakerPortuguese,
        textPortuguese: startNode.linePortuguese,
        textRussian: startNode.lineRussian,
        isUser: false,
        audioPath: startNode.audioPath,
      ),
    ];

    emit(
      ConversationActive(
        scenarios: allScenarios,
        activeScenario: scenario,
        currentNode: startNode,
        history: initialHistory,
        isFinished: startNode.options.isEmpty,
      ),
    );

    _playNodeAudio(startNode);
  }

  Future<void> selectOption(DialogueOption option) async {
    final s = state;
    if (s is ConversationActive) {
      await _repository.recordChoice(s.currentNode.id, option.id);

      final newHistory = List<DialogueMessageItem>.from(s.history)
        ..add(
          DialogueMessageItem(
            speaker: 'Você (Вы)',
            textPortuguese: option.textPortuguese,
            textRussian: option.textRussian,
            isUser: true,
          ),
        );

      if (option.nextNodeId == null || option.nextNodeId!.isEmpty) {
        emit(s.copyWith(history: newHistory, isFinished: true));
        return;
      }

      final nextNode = await _repository.getNode(option.nextNodeId!);
      if (nextNode == null) {
        emit(s.copyWith(history: newHistory, isFinished: true));
        return;
      }

      newHistory.add(
        DialogueMessageItem(
          speaker: nextNode.speakerPortuguese,
          textPortuguese: nextNode.linePortuguese,
          textRussian: nextNode.lineRussian,
          isUser: false,
          audioPath: nextNode.audioPath,
        ),
      );

      emit(
        s.copyWith(
          currentNode: nextNode,
          history: newHistory,
          isFinished: nextNode.options.isEmpty,
        ),
      );

      _playNodeAudio(nextNode);
    }
  }

  Future<void> playMessageAudio(DialogueMessageItem message) async {
    final currentDialect = await _settings.getDialect();
    final dialect = (state is ConversationActive)
        ? PortugueseDialect.fromCode((state as ConversationActive).activeScenario.dialect)
        : currentDialect;

    _audioService.playAudioOrSpeak(
      audioPathOrUrl: message.audioPath,
      fallbackText: message.textPortuguese,
      dialect: dialect,
    );
  }

  void _playNodeAudio(DialogueNodeEntity node) {
    final dialect = PortugueseDialect.fromCode(node.dialect);
    _audioService.playAudioOrSpeak(
      audioPathOrUrl: node.audioPath,
      fallbackText: node.linePortuguese,
      dialect: dialect,
    );
  }
}
