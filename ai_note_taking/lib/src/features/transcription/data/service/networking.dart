import 'dart:convert';
import 'package:ai_note_taking/src/features/transcription/data/service/transcription_request.dart';
import 'package:ai_note_taking/src/features/transcription/domain/model/transcription_response.dart';
import 'package:ai_note_taking/utils/constants.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData(TranscriptionRequest transcriptionRequest) async {
    final Uri url = Uri.parse(this.url);

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath(
          'file', transcriptionRequest.requestFilePath))
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

    if (response.statusCode == 200) {
      return TranscriptionResponse.fromJson(jsonDecode(responseBody));
    } else {
      print(response.statusCode);
    }
  }
}
