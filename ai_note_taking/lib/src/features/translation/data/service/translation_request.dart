import 'package:ai_note_taking/src/features/transcription/data/service/networking.dart';
import 'package:ai_note_taking/src/features/transcription/domain/model/response_format.dart';
import 'package:ai_note_taking/src/features/translation/domain/model/translation_response.dart';
import 'package:ai_note_taking/utils/credentials.dart';

class TranslationRequest {
  final Map<String, String> requestHeader = {
    'Authorization': 'Bearer $openAIBearerToken',
    'Content-Type': 'multipart/form-data',
  };
  late final String requestFilePath;
  final String requestModel = 'whisper-1';
  final String requestFeature = 'audio/translations';

  final String requestPrompt = '';
  final ResponseFormat requestResponseFormat = ResponseFormat.json;
  final int requestTemperature = 0;

  TranslationRequest({required this.requestFilePath});

  Future<TranslationResponse> getTranslation(String filePath) async {
    TranslationRequest request = TranslationRequest(requestFilePath: filePath);
    NetworkHelper networkHelper =
        NetworkHelper('$openAIBaseURL/$requestFeature');

    return await networkHelper.getTranslationData(request);
  }
}
