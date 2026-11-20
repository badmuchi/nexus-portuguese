import 'package:equatable/equatable.dart';
import '../../domain/entities/slang_entity.dart';

sealed class SlangState extends Equatable {
  const SlangState();

  @override
  List<Object?> get props => [];
}

final class SlangInitial extends SlangState {}

final class SlangLoading extends SlangState {}

final class SlangLoaded extends SlangState {
  final List<SlangEntity> slangList;

  const SlangLoaded(this.slangList);

  @override
  List<Object?> get props => [slangList];
}

final class SlangError extends SlangState {
  final String message;

  const SlangError(this.message);

  @override
  List<Object?> get props => [message];
}
