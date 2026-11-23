import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/core/settings/app_settings_storage.dart';
import '../../domain/entities/bazar_entities.dart';
import '../../domain/repositories/bazar_repository.dart';
import 'bargain_simulator_state.dart';

class BargainSimulatorCubit extends Cubit<BargainSimulatorState> {
  final BazarRepository _repository;
  final HybridAudioPlaybackService _audioService;

  BargainSimulatorCubit({
    required BargainScenarioEntity scenario,
    required BazarRepository repository,
    required HybridAudioPlaybackService audioService,
  })  : _repository = repository,
        _audioService = audioService,
        super(BargainSimulatorState(
          scenario: scenario,
          currentPrice: scenario.initialPrice,
        ));

  void applyTactic() {
    if (state.hasOfferedCurrent) return;

    final step = state.currentStep;
    final isFinal = state.isLastStep;

    emit(state.copyWith(
      hasOfferedCurrent: true,
      currentPrice: step.offeredPrice,
      isSuccess: isFinal,
    ));

    playVendorAudio();

    if (isFinal) {
      _repository.recordMarketPurchase(
        marketId: state.scenario.id,
        itemsCount: 1,
        totalSpent: step.offeredPrice,
      );
    }
  }

  void nextStep() {
    if (!state.hasOfferedCurrent || state.isLastStep) return;

    stopAudio();
    emit(state.copyWith(
      currentStepIndex: state.currentStepIndex + 1,
      hasOfferedCurrent: false,
    ));
  }

  Future<void> playVendorAudio() async {
    final text = state.currentStep.vendorResponsePt;
    emit(state.copyWith(isPlayingAudio: true));

    final targetDialect = state.scenario.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    await _audioService.playAudioOrSpeak(
      fallbackText: text,
      dialect: targetDialect,
      rate: 1.0,
    );

    if (!isClosed) {
      emit(state.copyWith(isPlayingAudio: false));
    }
  }

  Future<void> playBuyerAudio() async {
    final text = state.currentStep.buyerPhrasePt;
    emit(state.copyWith(isPlayingAudio: true));

    final targetDialect = state.scenario.isPtPt
        ? PortugueseDialect.european
        : PortugueseDialect.brazilian;

    await _audioService.playAudioOrSpeak(
      fallbackText: text,
      dialect: targetDialect,
      rate: 0.95,
    );

    if (!isClosed) {
      emit(state.copyWith(isPlayingAudio: false));
    }
  }

  Future<void> stopAudio() async {
    await _audioService.stop();
    if (!isClosed) {
      emit(state.copyWith(isPlayingAudio: false));
    }
  }

  void restart() {
    stopAudio();
    emit(BargainSimulatorState(
      scenario: state.scenario,
      currentPrice: state.scenario.initialPrice,
      currentStepIndex: 0,
      hasOfferedCurrent: false,
      isSuccess: false,
    ));
  }

  @override
  Future<void> close() {
    _audioService.stop();
    return super.close();
  }
}
