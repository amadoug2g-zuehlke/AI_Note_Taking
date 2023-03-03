import 'package:flutter/material.dart';

class TranscriptionScreen extends StatefulWidget {
  const TranscriptionScreen({Key? key}) : super(key: key);

  @override
  State<TranscriptionScreen> createState() => _TranscriptionScreenState();
}

class _TranscriptionScreenState extends State<TranscriptionScreen> {
  //TODO: Take a path as an argument from the recording screen

  //TODO: Create function to call the Whisper API for transcription

  @override
  Widget build(BuildContext context) {
    //TODO: Create the transcription interface (text field, language, loading)
    return const Placeholder();
  }
}
