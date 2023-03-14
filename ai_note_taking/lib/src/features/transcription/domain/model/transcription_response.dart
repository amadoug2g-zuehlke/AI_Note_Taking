class TranscriptionResponse {
  TranscriptionResponse();

  late String text;

  TranscriptionResponse.fromJson(Map<String, dynamic> json)
      : text = json['text'].toString();

  @override
  String toString() {
    return 'Text: $text';
  }
}
