import 'package:ai_note_taking/src/features/transcription/presentation/screens/transcription_screen.dart';
import 'package:flutter/material.dart';

//TODO: Add routes
void main() {
  runApp(
    const MaterialApp(
      title: 'Speech to Text App',
      home: TranscriptionScreen(),
    ),
  );
}
