import 'package:ai_note_taking/src/features/transcription/presentation/screens/transcription_screen.dart';
import 'package:ai_note_taking/src/features/translation/presentation/screens/translation_screen.dart';
import 'package:ai_note_taking/utils/constants.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void showSupportedLanguages() {
    Widget continueButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(supportedLanguagesTitle),
      content: const Text(
        supportedLanguagesList,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundedMenuIcon(
                menuDestination:
                    TranscriptionScreen.navTranscriptionScreen.toString(),
                menuButton: const Icon(
                  Icons.transcribe_rounded,
                  color: Colors.white,
                  size: 100,
                ),
                menuDescription: transcriptionMenuDescription),
            RoundedMenuIcon(
              menuDestination:
                  TranslationScreen.navTranslationScreen.toString(),
              menuButton: const Icon(
                Icons.translate_rounded,
                color: Colors.white,
                size: 100,
              ),
              menuDescription: translationMenuDescription,
            ),
            TextButton(
                onPressed: () => showSupportedLanguages(),
                child: const Text(supportedLanguagesTitle)),
          ],
        ),
      ),
    );
  }
}

class RoundedMenuIcon extends StatelessWidget {
  const RoundedMenuIcon({
    super.key,
    required this.menuDestination,
    required this.menuButton,
    required this.menuDescription,
  });

  final Icon menuButton;
  final String menuDescription;
  final String menuDestination;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, menuDestination);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
            ),
            child: menuButton,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 250,
          child: Text(
            menuDescription,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
