import 'package:flame_audio/flame_audio.dart';

typedef StopFunction = Future<void> Function();

class AudioManager {
  static AudioPool? _diceSoundPool;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      try {
        _diceSoundPool = await AudioPool.createFromAsset(
          path: 'audio/dice.mp3',
          maxPlayers: 3,
        );
        _isInitialized = true;
      } catch (e) {
        // Audio file not found, continuing without sound
        _isInitialized = true; // Mark as initialized to prevent retries
      }
    }
  }

  static Future<StopFunction> playDiceSound({double volume = 1.0}) async {
    if (_diceSoundPool != null) {
      try {
        return await _diceSoundPool!.start(volume: volume);
      } catch (e) {
        // Error playing dice sound
      }
    }
    // Return a dummy stop function if no audio
    return () async {};
  }

  static Future<void> dispose() async {
    try {
      await _diceSoundPool?.dispose();
    } catch (e) {
      // Error disposing audio
    }
    _diceSoundPool = null;
    _isInitialized = false;
  }
}
