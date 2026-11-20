import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const Failure(this.message, {this.cause, this.stackTrace});

  @override
  List<Object?> get props => [message, cause, stackTrace];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.cause, super.stackTrace});
}

class AudioFailure extends Failure {
  const AudioFailure(super.message, {super.cause, super.stackTrace});
}

class SpeechRecognitionFailure extends Failure {
  const SpeechRecognitionFailure(super.message, {super.cause, super.stackTrace});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.cause, super.stackTrace});
}
