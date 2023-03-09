import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            RoundedMenuIcon(
                menuDestination: '/transcription',
                menuButton: Icon(
                  Icons.transcribe_rounded,
                  color: Colors.white,
                  size: 100,
                ),
                menuDescription:
                    'Transcribe your audios into their original language'),
            RoundedMenuIcon(
              menuDestination: '/translation',
              menuButton: Icon(
                Icons.translate_rounded,
                color: Colors.white,
                size: 100,
              ),
              menuDescription:
                  'Transcribe and translate your audios from their original language to english',
            ),
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
