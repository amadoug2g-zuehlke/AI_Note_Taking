import 'dart:convert';
import 'package:ai_note_taking/src/features/transcription/data/service/transcription_request.dart';
import 'package:ai_note_taking/src/features/transcription/domain/model/transcription_response.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  /// Try to define the return type more precise.
  /// Managing the possible returns separate each time generates a lot of redundant code.
  /// By defining it e.g. Future<TranscriptionResponse?> you define it and only have
  /// to verify your return when calling the function. You can also make this function
  /// throwing and then use this possible throw (when failed) to display some onscreen dialog.
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
      // I'd recommend debugPrint as this will also print in production
      print(response.statusCode);
    }
  }
}
