import 'package:flutter/material.dart';

class TranslationScreen extends StatelessWidget {
  const TranslationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation'),
      ),
      body: const Center(
        child: Text(
          'TBD',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
