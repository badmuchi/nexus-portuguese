import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/stories_repository.dart';
import 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final StoriesRepository _repository;

  StoriesCubit({required StoriesRepository repository})
      : _repository = repository,
        super(StoriesInitial());

  Future<void> loadStories() async {
    emit(StoriesLoading());
    final result = await _repository.getAllStories();
    result.fold(
      onSuccess: (data) => emit(StoriesLoaded(data)),
      onFailure: (msg, _) => emit(StoriesError(msg)),
    );
  }
}
