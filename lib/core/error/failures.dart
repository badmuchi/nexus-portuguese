import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final Object? cause;

  const Failure(this.message, [this.cause]);

  @override
  List<Object?> get props => [message, cause];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.cause]);
}

class AudioFailure extends Failure {
  const AudioFailure(super.message, [super.cause]);
}

class SpeechRecognitionFailure extends Failure {
  const SpeechRecognitionFailure(super.message, [super.cause]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.cause]);
}
