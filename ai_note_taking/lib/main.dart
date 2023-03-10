import 'package:ai_note_taking/src/features/transcription/presentation/screens/shared_transcription_screen.dart';
import 'package:ai_note_taking/src/features/transcription/presentation/screens/transcription_screen.dart';
import 'package:ai_note_taking/src/features/translation/presentation/screens/translation_screen.dart';
import 'package:ai_note_taking/src/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Speech to Text',
      initialRoute: WelcomeScreen.routeName,
      routes: {
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        TranscriptionScreen.routeName: (context) => const TranscriptionScreen(),
        TranslationScreen.routeName: (context) => const TranslationScreen(),
        SharedTranscriptionScreen.routeName: (context) =>
            const SharedTranscriptionScreen(),
      },
    ),
  );
}
