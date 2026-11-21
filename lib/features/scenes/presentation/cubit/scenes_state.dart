import 'package:equatable/equatable.dart';
import '../../domain/entities/portuguese_life_scene.dart';

sealed class ScenesState extends Equatable {
  const ScenesState();

  @override
  List<Object?> get props => [];
}

final class ScenesLoading extends ScenesState {
  const ScenesLoading();
}

final class ScenesLoaded extends ScenesState {
  final List<PortugueseLifeScene> scenes;
  final SceneCategory? selectedCategory;
  final Map<String, SceneProgressEntity> progressMap;
  final String? activePlayingText;

  const ScenesLoaded({
    required this.scenes,
    this.selectedCategory,
    this.progressMap = const {},
    this.activePlayingText,
  });

  List<PortugueseLifeScene> get filteredScenes {
    if (selectedCategory == null) return scenes;
    return scenes.where((s) => s.category == selectedCategory).toList();
  }

  ScenesLoaded copyWith({
    List<PortugueseLifeScene>? scenes,
    SceneCategory? Function()? selectedCategory,
    Map<String, SceneProgressEntity>? progressMap,
    String? Function()? activePlayingText,
  }) {
    return ScenesLoaded(
      scenes: scenes ?? this.scenes,
      selectedCategory: selectedCategory != null ? selectedCategory() : this.selectedCategory,
      progressMap: progressMap ?? this.progressMap,
      activePlayingText: activePlayingText != null ? activePlayingText() : this.activePlayingText,
    );
  }

  @override
  List<Object?> get props => [
        scenes,
        selectedCategory,
        progressMap,
        activePlayingText,
      ];
}

final class ScenesError extends ScenesState {
  final String message;

  const ScenesError(this.message);

  @override
  List<Object?> get props => [message];
}
