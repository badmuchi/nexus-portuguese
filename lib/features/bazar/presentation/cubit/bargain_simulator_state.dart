import 'package:equatable/equatable.dart';
import '../../domain/entities/bazar_entities.dart';

class BargainSimulatorState extends Equatable {
  final BargainScenarioEntity scenario;
  final int currentStepIndex;
  final double currentPrice;
  final bool hasOfferedCurrent;
  final bool isSuccess;
  final bool isPlayingAudio;

  const BargainSimulatorState({
    required this.scenario,
    this.currentStepIndex = 0,
    required this.currentPrice,
    this.hasOfferedCurrent = false,
    this.isSuccess = false,
    this.isPlayingAudio = false,
  });

  BargainStepEntity get currentStep => scenario.steps[currentStepIndex];

  bool get isLastStep => currentStepIndex == scenario.steps.length - 1;

  double get savings => scenario.initialPrice - currentPrice;

  double get discountPercent =>
      ((savings / scenario.initialPrice) * 100).clamp(0.0, 100.0);

  BargainSimulatorState copyWith({
    BargainScenarioEntity? scenario,
    int? currentStepIndex,
    double? currentPrice,
    bool? hasOfferedCurrent,
    bool? isSuccess,
    bool? isPlayingAudio,
  }) {
    return BargainSimulatorState(
      scenario: scenario ?? this.scenario,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      currentPrice: currentPrice ?? this.currentPrice,
      hasOfferedCurrent: hasOfferedCurrent ?? this.hasOfferedCurrent,
      isSuccess: isSuccess ?? this.isSuccess,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
    );
  }

  @override
  List<Object?> get props => [
        scenario,
        currentStepIndex,
        currentPrice,
        hasOfferedCurrent,
        isSuccess,
        isPlayingAudio,
      ];
}
