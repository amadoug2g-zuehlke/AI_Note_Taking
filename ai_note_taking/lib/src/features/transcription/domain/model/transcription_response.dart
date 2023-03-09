/// There is a nice tool that helps you with your DTOs and models
/// https://javiercbk.github.io/json_to_dart/

class TranscriptionResponse {
  TranscriptionResponse();

  late String text;

  TranscriptionResponse.fromJson(Map<String, dynamic> json)
      : text = json['text'];

  @override
  String toString() {
    return 'Text: $text';
  }
}
