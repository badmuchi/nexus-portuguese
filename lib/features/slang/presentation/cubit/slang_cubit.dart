import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/slang_repository.dart';
import 'slang_state.dart';

class SlangCubit extends Cubit<SlangState> {
  final SlangRepository _repository;

  SlangCubit({required SlangRepository repository})
      : _repository = repository,
        super(SlangInitial());

  Future<void> loadSlang() async {
    emit(SlangLoading());
    final result = await _repository.getAllSlang();
    result.fold(
      onSuccess: (data) => emit(SlangLoaded(data)),
      onFailure: (msg, _) => emit(SlangError(msg)),
    );
  }
}
