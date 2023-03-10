import 'package:ai_note_taking/src/features/transcription/data/service/networking.dart';
import 'package:ai_note_taking/src/features/transcription/domain/model/response_format.dart';
import 'package:ai_note_taking/src/features/transcription/domain/model/transcription_response.dart';
import 'package:ai_note_taking/utils/credentials.dart';

class TranscriptionRequest {
  final Map<String, String> requestHeader = {
    'Authorization': 'Bearer $openAIBearerToken',
    'Content-Type': 'multipart/form-data',
  };
  late final String requestFilePath;
  final String requestModel = 'whisper-1';
  final String requestFeature = 'audio/transcriptions';

  final String requestPrompt = '';
  final ResponseFormat requestResponseFormat = ResponseFormat.json;
  final int requestTemperature = 0;
  final String requestLanguage = '';

  TranscriptionRequest({required this.requestFilePath});

  Future<TranscriptionResponse> getTranscription(String filePath) async {
    TranscriptionRequest request =
        TranscriptionRequest(requestFilePath: filePath);
    NetworkHelper networkHelper =
        NetworkHelper('$openAIBaseURL/$requestFeature');

    return await networkHelper.getTranscriptionData(request);
  }

//TODO: Implement methods to change arguments for custom requests
}

enum TranscriptionPrompt {
  //TODO: Add the right prompts
  punctuation,
  fillerWords;

  String example() {
    switch (this) {
      case punctuation:
        {
          return 'Hello, welcome to my lecture.';
        }
      case fillerWords:
        {
          return 'Umm, let me think like, hmm... Okay, here\'s what I\'m, like, thinking.';
        }
      default:
        {
          return '';
        }
    }
  }
}
