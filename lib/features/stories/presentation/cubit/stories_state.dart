import 'package:equatable/equatable.dart';
import '../../domain/entities/story_entity.dart';

sealed class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object?> get props => [];
}

final class StoriesInitial extends StoriesState {}

final class StoriesLoading extends StoriesState {}

final class StoriesLoaded extends StoriesState {
  final List<StoryEntity> stories;

  const StoriesLoaded(this.stories);

  @override
  List<Object?> get props => [stories];
}

final class StoriesError extends StoriesState {
  final String message;

  const StoriesError(this.message);

  @override
  List<Object?> get props => [message];
}
