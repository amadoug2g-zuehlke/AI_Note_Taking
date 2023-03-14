import 'package:flutter/material.dart';

class TranscriptionBox extends StatelessWidget {
  const TranscriptionBox({
    required String text,
    super.key,
  }) : _text = text;

  final String _text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Text(
            _text,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
