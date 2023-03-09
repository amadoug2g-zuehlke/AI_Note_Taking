import 'package:flutter/material.dart';

class TranscriptionBox extends StatelessWidget {
  const TranscriptionBox({
    super.key,
    required String text,
  }) : _text = text;

  final String _text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Text(
            _text,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
