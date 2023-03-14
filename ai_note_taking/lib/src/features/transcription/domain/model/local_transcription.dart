import 'package:ai_note_taking/src/features/transcription/domain/model/transcript_type.dart';

class LocalTranscriptionModel {
  LocalTranscriptionModel();

  late String transcriptionLanguage;
  late String transcriptionSourcePath;
  late String transcriptionText;
  late TranscriptType type;
}
