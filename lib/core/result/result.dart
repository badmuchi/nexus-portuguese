import 'package:equatable/equatable.dart';
import '../error/failures.dart';

sealed class Result<T> extends Equatable {
  const Result();

  const factory Result.ok(T data) = Success<T>;
  factory Result.err(Failure failure) = FailureResult<T>.fromFailure;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  bool get isOk => isSuccess;
  T get value => (this as Success<T>).data;
  Failure? get failure => failureOrNull;

  T? get dataOrNull => switch (this) {
        Success(data: final d) => d,
        FailureResult() => null,
      };

  String? get errorOrNull => switch (this) {
        Success() => null,
        FailureResult(message: final m) => m,
      };

  Failure? get failureOrNull => switch (this) {
        Success() => null,
        FailureResult(failure: final f) => f,
      };

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String message, Object? cause) onFailure,
  }) {
    return switch (this) {
      Success(data: final d) => onSuccess(d),
      FailureResult(message: final m, cause: final c) => onFailure(m, c),
    };
  }
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

final class FailureResult<T> extends Result<T> {
  final String message;
  final Object? cause;
  @override
  final Failure? failure;

  const FailureResult(this.message, [this.cause]) : failure = null;

  FailureResult.fromFailure(Failure f)
      : message = f.message,
        cause = f.cause,
        failure = f;

  @override
  List<Object?> get props => [message, cause, failure];
}
