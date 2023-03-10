import 'package:ai_note_taking/src/features/transcription/domain/model/transcript_type.dart';

class LocalTranscriptionModel {
  late String transcriptionText;
  late String transcriptionSourcePath;
  late String transcriptionLanguage;
  late TranscriptType type;

  LocalTranscriptionModel();
}
