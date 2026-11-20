import 'package:equatable/equatable.dart';
import '../../domain/entities/progress_stats_entity.dart';

sealed class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

final class ProgressInitial extends ProgressState {}

final class ProgressLoading extends ProgressState {}

final class ProgressLoaded extends ProgressState {
  final ProgressStatsEntity stats;

  const ProgressLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

final class ProgressError extends ProgressState {
  final String message;

  const ProgressError(this.message);

  @override
  List<Object?> get props => [message];
}
