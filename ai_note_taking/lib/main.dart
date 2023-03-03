import 'dart:async';
import 'package:ai_note_taking/src/features/recording/presentation/screens/audio_recording_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:record/record.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AudioRecordingScreen(),
    ),
  );
}
