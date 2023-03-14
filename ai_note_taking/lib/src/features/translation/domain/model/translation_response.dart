class TranslationResponse {
  TranslationResponse({required this.text});

  TranslationResponse.fromJson(Map<String, dynamic> json)
      : text = json['text'].toString();

  final String text;

  @override
  String toString() {
    return 'Text: $text';
  }
}
