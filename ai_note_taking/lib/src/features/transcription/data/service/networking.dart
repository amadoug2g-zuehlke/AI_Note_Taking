import 'dart:convert';
import 'package:ai_note_taking/src/features/transcription/data/service/transcription_request.dart';
import 'package:ai_note_taking/src/features/transcription/domain/model/transcription_response.dart';
import 'package:ai_note_taking/src/features/translation/data/service/translation_request.dart';
import 'package:ai_note_taking/src/features/translation/domain/model/translation_response.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future<TranscriptionResponse> getTranscriptionData(
    TranscriptionRequest transcriptionRequest,
  ) async {
    final Uri url = Uri.parse(this.url);

    final request = http.MultipartRequest('POST', url)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          transcriptionRequest.requestFilePath,
        ),
      )
      ..fields['model'] = transcriptionRequest.requestModel
      ..fields['prompt'] = transcriptionRequest.requestPrompt
      ..fields['response_format'] =
          transcriptionRequest.requestResponseFormat.name
      ..fields['temperature'] =
          transcriptionRequest.requestTemperature.toString()
      ..fields['language'] = transcriptionRequest.requestLanguage;

    request.headers.addAll(transcriptionRequest.requestHeader);

    final http.StreamedResponse response = await request.send();
    final String responseBody = await response.stream.bytesToString();

    switch (response.statusCode) {
      case 200:
        {
          return TranscriptionResponse.fromJson(
            jsonDecode(responseBody) as Map<String, dynamic>,
          );
        }
      default:
        {
          return throw Exception(
            'An error occurred: ${response.reasonPhrase} [${response.statusCode}]',
          );
        }
    }
  }

  Future<TranslationResponse> getTranslationData(
    TranslationRequest translationRequest,
  ) async {
    final Uri url = Uri.parse(this.url);

    final request = http.MultipartRequest('POST', url)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          translationRequest.requestFilePath,
        ),
      )
      ..fields['model'] = translationRequest.requestModel
      ..fields['prompt'] = translationRequest.requestPrompt
      ..fields['response_format'] =
          translationRequest.requestResponseFormat.name
      ..fields['temperature'] =
          translationRequest.requestTemperature.toString();

    request.headers.addAll(translationRequest.requestHeader);

    final http.StreamedResponse response = await request.send();
    final String responseBody = await response.stream.bytesToString();

    switch (response.statusCode) {
      case 200:
        {
          return TranslationResponse.fromJson(
            jsonDecode(responseBody) as Map<String, dynamic>,
          );
        }
      default:
        {
          return throw Exception(
            'An error occurred: ${response.reasonPhrase} [${response.statusCode}]',
          );
        }
    }
  }
}
