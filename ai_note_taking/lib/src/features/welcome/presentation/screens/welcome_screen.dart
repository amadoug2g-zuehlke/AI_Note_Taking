import 'dart:async';
import 'package:ai_note_taking/src/features/transcription/domain/model/shared_screen_arguments.dart';
import 'package:ai_note_taking/src/features/transcription/presentation/screens/shared_transcription_screen.dart';
import 'package:ai_note_taking/src/features/transcription/presentation/screens/transcription_screen.dart';
import 'package:ai_note_taking/src/features/translation/presentation/screens/translation_screen.dart';
import 'package:ai_note_taking/src/features/welcome/presentation/components/round_menu_icon.dart';
import 'package:ai_note_taking/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static String routeName = "/";

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  //region Variables
  late StreamSubscription? _dataStreamSubscription;
  List<SharedMediaFile>? _sharedFiles = [];
  //endregion

  //region Override Methods
  @override
  void initState() {
    super.initState();

    _dataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> files) {
      setState(() {
        _sharedFiles = files;
      });
    });

    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> files) {
      if (files != null) {
        setState(() {
          _sharedFiles = files;
        });
      }
    });
  }

  @override
  void dispose() {
    _dataStreamSubscription!.cancel();
    super.dispose();
  }
  //endregion

  //region Navigation
  void chooseNavigation(List<SharedMediaFile>? files) {
    if (_sharedFiles?.length != 0) {
      Navigator.pushNamed(
        context,
        SharedTranscriptionScreen.routeName,
        arguments: SharedScreenArguments(_sharedFiles!),
      );
    } else {
      Fluttertoast.showToast(
        msg: noFileSelectedText,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
  //endregion

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
                menuDestination: TranscriptionScreen.routeName.toString(),
                menuButton: const Icon(
                  Icons.transcribe_rounded,
                  color: Colors.white,
                  size: 100,
                ),
                menuDescription: transcriptionMenuDescription),
            RoundedMenuIcon(
              menuDestination: TranslationScreen.routeName.toString(),
              menuButton: const Icon(
                Icons.translate_rounded,
                color: Colors.white,
                size: 100,
              ),
              menuDescription: translationMenuDescription,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () => showSupportedLanguages(),
                    child: const Text(supportedLanguagesTitle)),
                TextButton(
                    onPressed: () => chooseNavigation(_sharedFiles),
                    child: const Text(sharedFileTranslationTitle)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
