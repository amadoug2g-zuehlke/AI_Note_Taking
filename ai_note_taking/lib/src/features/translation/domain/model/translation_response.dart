class TranslationResponse {
  TranslationResponse();

  TranslationResponse.fromJson(Map<String, dynamic> json)
      : text = json['text'].toString();

  late String text;

  @override
  String toString() {
    return 'Text: $text';
  }
}
