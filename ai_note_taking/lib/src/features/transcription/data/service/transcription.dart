import 'dart:convert';
import 'package:ai_note_taking/src/features/transcription/data/service/networking.dart';
import 'package:ai_note_taking/src/features/transcription/domain/model/transcription_response.dart';
import 'package:ai_note_taking/utils/constants.dart';

class TranscriptionModel {
  final String promptModel = 'whisper-1';
  final String promptFeature = 'audio/transcriptions';

  Future<TranscriptionResponse> getTranscription(String filePath) async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer $openAIBearerToken',
      'Content-Type': 'multipart/form-data',
    };

    String url = '$openAIBaseURL/$promptFeature';

    NetworkHelper networkHelper = NetworkHelper(url);

    var transcriptionResponse = await networkHelper.getData(headers, filePath);
    return transcriptionResponse;
  }
}
