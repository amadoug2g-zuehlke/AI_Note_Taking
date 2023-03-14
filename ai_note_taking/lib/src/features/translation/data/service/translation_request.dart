import 'package:ai_note_taking/src/features/transcription/data/service/networking.dart';
import 'package:ai_note_taking/src/features/transcription/domain/model/response_format.dart';
import 'package:ai_note_taking/src/features/translation/domain/model/translation_response.dart';
import 'package:ai_note_taking/utils/credentials.dart';

class TranslationRequest {
  TranslationRequest({required this.requestFilePath});

  final String requestFeature = 'audio/translations';
  late final String requestFilePath;
  final Map<String, String> requestHeader = {
    'Authorization': 'Bearer $openAIBearerToken',
    'Content-Type': 'multipart/form-data',
  };

  final String requestModel = 'whisper-1';
  final String requestPrompt = '';
  final ResponseFormat requestResponseFormat = ResponseFormat.json;
  final int requestTemperature = 0;

  Future<TranslationResponse> getTranslation(String filePath) async {
    final TranslationRequest request =
        TranslationRequest(requestFilePath: filePath);
    final NetworkHelper networkHelper =
        NetworkHelper('$openAIBaseURL/$requestFeature');

    return await networkHelper.getTranslationData(request);
  }
}
