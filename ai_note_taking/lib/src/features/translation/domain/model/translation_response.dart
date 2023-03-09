class TranslationResponse {
  TranslationResponse();

  late String text;

  TranslationResponse.fromJson(Map<String, dynamic> json) : text = json['text'];

  @override
  String toString() {
    return 'Text: $text';
  }
}
