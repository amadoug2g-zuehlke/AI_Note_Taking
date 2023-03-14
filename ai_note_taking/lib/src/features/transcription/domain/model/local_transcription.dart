import 'package:ai_note_taking/src/features/transcription/domain/model/transcript_type.dart';

class LocalTranscriptionModel {
  LocalTranscriptionModel({
    required this.transcriptionLanguage,
    required this.transcriptionSourcePath,
    required this.transcriptionText,
    required this.type,
  });

  final String transcriptionLanguage;
  final String transcriptionSourcePath;
  final String transcriptionText;
  final TranscriptType type;
}
