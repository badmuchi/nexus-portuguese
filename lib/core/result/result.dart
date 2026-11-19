import 'package:equatable/equatable.dart';

sealed class Result<T> extends Equatable {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  T? get dataOrNull => switch (this) {
        Success(data: final d) => d,
        FailureResult() => null,
      };

  String? get errorOrNull => switch (this) {
        Success() => null,
        FailureResult(message: final m) => m,
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
  const FailureResult(this.message, [this.cause]);

  @override
  List<Object?> get props => [message, cause];
}
