abstract class AudioPlaybackService {
  Future<void> playAsset(String assetPath);
  Future<void> playUrl(String url);
  Future<void> stop();
  Future<void> pause();
  Future<void> resume();
  Stream<bool> get isPlayingStream;
  Future<void> dispose();
}
