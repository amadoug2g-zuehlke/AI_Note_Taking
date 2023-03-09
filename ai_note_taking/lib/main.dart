import 'package:ai_note_taking/src/features/transcription/presentation/screens/shared_transcription_screen.dart';
import 'package:ai_note_taking/src/features/transcription/presentation/screens/transcription_screen.dart';
import 'package:ai_note_taking/src/features/translation/presentation/screens/translation_screen.dart';
import 'package:ai_note_taking/src/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Speech to Text',
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        TranscriptionScreen.navTranscriptionScreen: (context) =>
            const TranscriptionScreen(),
        TranslationScreen.navTranslationScreen: (context) =>
            const TranslationScreen(),
        SharedTranscriptionScreen.navSharedTranslationScreen: (context) =>
            const SharedTranscriptionScreen(),
      },
    ),
  );
}

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  //TODO: Add check for sharing intent at startup, navigate to SharedTranscriptionScreen with data if available

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
