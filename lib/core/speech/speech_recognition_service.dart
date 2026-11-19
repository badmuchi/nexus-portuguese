import 'dart:async';

abstract class SpeechRecognitionService {
  Stream<String> get textStream;
  Stream<bool> get isListeningStream;

  Future<void> startListening({String localeId = 'pt-BR'});
  Future<void> stopListening();
  Future<void> cancel();
  void dispose();
}

class DefaultSpeechRecognitionService implements SpeechRecognitionService {
  final _textController = StreamController<String>.broadcast();
  final _isListeningController = StreamController<bool>.broadcast();
  bool _isListening = false;
  bool get isListening => _isListening;

  @override
  Stream<String> get textStream => _textController.stream;

  @override
  Stream<bool> get isListeningStream => _isListeningController.stream;

  @override
  Future<void> startListening({String localeId = 'pt-BR'}) async {
    _isListening = true;
    _isListeningController.add(true);
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
    _isListeningController.add(false);
  }

  @override
  Future<void> cancel() async {
    _isListening = false;
    _isListeningController.add(false);
  }

  void submitRecognizedText(String text) {
    _textController.add(text);
  }

  @override
  void dispose() {
    _textController.close();
    _isListeningController.close();
  }
}
