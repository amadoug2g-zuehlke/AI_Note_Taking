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
