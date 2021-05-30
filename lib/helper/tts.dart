import 'package:flutter_tts/flutter_tts.dart';

class TTS {
  FlutterTts _fts;
  TTS() {
    _fts = FlutterTts();
  }

  Future tts(String textToSpeak) async {
    await _fts.setLanguage("en-US");
    await _fts.setSpeechRate(0.5);
    await _fts.setPitch(1);
    await _fts.speak(textToSpeak);
  }
}
