import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/progress_repository.dart';
import 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final ProgressRepository _repository;

  ProgressCubit({required ProgressRepository repository})
      : _repository = repository,
        super(ProgressInitial());

  Future<void> loadStats() async {
    emit(ProgressLoading());
    final result = await _repository.getProgressStats();
    result.fold(
      onSuccess: (data) => emit(ProgressLoaded(data)),
      onFailure: (msg, _) => emit(ProgressError(msg)),
    );
  }
}
