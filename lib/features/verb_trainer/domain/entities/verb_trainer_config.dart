import 'package:equatable/equatable.dart';

enum TrainerMode {
  sprint60('sprint60', 'Блиц-Спринт', '60 секунд на максимум форм', 60, null),
  drill15('drill15', 'Дрилл (15 форм)', 'Спокойная тренировка с разбором', null, 15),
  marathon30('marathon30', 'Марафон (30 форм)', 'Интенсивное закрепление', null, 30);

  final String id;
  final String titleRu;
  final String subtitleRu;
  final int? durationSeconds;
  final int? questionCount;

  const TrainerMode(
    this.id,
    this.titleRu,
    this.subtitleRu,
    this.durationSeconds,
    this.questionCount,
  );
}

enum TenseFilter {
  all('all', 'Все времена'),
  presente('presente_indicativo', 'Presente (Настоящее)'),
  preteritoPerfeito('preterito_perfeito', 'Pretérito Perfeito (Прошедшее)'),
  preteritoImperfeito('preterito_imperfeito', 'Pretérito Imperfeito (Длительное)'),
  subjuntivo('presente_subjuntivo', 'Subjuntivo (Сослагательное)');

  final String rawTense;
  final String labelRu;

  const TenseFilter(this.rawTense, this.labelRu);
}

class VerbTrainerConfig extends Equatable {
  final TrainerMode mode;
  final TenseFilter tenseFilter;
  final bool irregularsOnly;

  const VerbTrainerConfig({
    this.mode = TrainerMode.sprint60,
    this.tenseFilter = TenseFilter.all,
    this.irregularsOnly = false,
  });

  VerbTrainerConfig copyWith({
    TrainerMode? mode,
    TenseFilter? tenseFilter,
    bool? irregularsOnly,
  }) {
    return VerbTrainerConfig(
      mode: mode ?? this.mode,
      tenseFilter: tenseFilter ?? this.tenseFilter,
      irregularsOnly: irregularsOnly ?? this.irregularsOnly,
    );
  }

  @override
  List<Object?> get props => [mode, tenseFilter, irregularsOnly];
}
