import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/interview_scenario_entity.dart';
import '../../domain/repositories/career_repository.dart';
import 'interview_simulator_state.dart';

class InterviewSimulatorCubit extends Cubit<InterviewSimulatorState> {
  final CareerRepository _repository;
  final HybridAudioPlaybackService _audioService;

  InterviewSimulatorCubit({
    required InterviewScenarioEntity scenario,
    required CareerRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(InterviewSimulatorState(scenario: scenario));

  void selectOption(int optionIndex) {
    if (state.isAnswered) return;

    final q = state.currentQuestion;
    if (optionIndex < 0 || optionIndex >= q.options.length) return;

    final opt = q.options[optionIndex];
    final newScore = state.totalScore + opt.points;

    emit(state.copyWith(
      selectedOptionIndex: optionIndex,
      isAnswered: true,
      totalScore: newScore,
    ));
  }

  void nextQuestion() {
    if (!state.isAnswered) return;

    if (state.isLastQuestion) {
      emit(state.copyWith(isCompleted: true));
      _repository.recordInterviewCompleted(
        scenarioId: state.scenario.id,
        score: state.totalScore,
        maxScore: state.scenario.maxScore,
      );
    } else {
      emit(state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        isAnswered: false,
        clearSelectedOption: true,
      ));
    }
  }

  void playQuestionAudio() {
    final dialect = state.scenario.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    _audioService.playAudioOrSpeak(
      fallbackText: state.currentQuestion.questionPt,
      dialect: dialect,
    );
  }

  void playOptionAudio(String text) {
    final dialect = state.scenario.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    _audioService.playAudioOrSpeak(
      fallbackText: text,
      dialect: dialect,
    );
  }

  void restart() {
    emit(InterviewSimulatorState(scenario: state.scenario));
  }
}
