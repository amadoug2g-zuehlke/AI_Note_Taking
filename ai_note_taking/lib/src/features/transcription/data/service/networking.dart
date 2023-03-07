import 'dart:convert';
import 'package:ai_note_taking/src/features/transcription/domain/model/transcription_response.dart';
import 'package:ai_note_taking/utils/constants.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;
  final String promptModel = 'whisper-1';

  Future getData(Map<String, String> headers, String filePath) async {
    final Uri url = Uri.parse(this.url);

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', filePath))
      ..fields['model'] = promptModel;

    request.headers.addAll(headers);

    final http.StreamedResponse response = await request.send();
    final String responseBody = await response.stream.bytesToString();

    print(responseBody);

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();

      return TranscriptionResponse.fromJson(jsonDecode(result));
    } else {
      print(response.statusCode);
    }
  }
}
