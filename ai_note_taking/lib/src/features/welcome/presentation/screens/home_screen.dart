import 'dart:async';

import 'package:ai_note_taking/src/features/transcription/domain/model/shared_screen_arguments.dart';
import 'package:ai_note_taking/src/features/transcription/presentation/screens/shared_transcription_screen.dart';
import 'package:ai_note_taking/src/features/transcription/presentation/screens/transcription_screen.dart';
import 'package:ai_note_taking/src/features/translation/presentation/screens/translation_screen.dart';
import 'package:ai_note_taking/src/features/welcome/presentation/components/action_button.dart';
import 'package:ai_note_taking/src/features/welcome/presentation/components/expandable_fab.dart';
import 'package:ai_note_taking/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

//TODO: Redesign welcome_screen as home_screen
//TODO: Create audio notes list
//TODO: Create Expandable FAB menu for transcriptions & translations
//TODO: Save audio transcriptions as a list of LocalTranscript
//TODO: Add menu for shared file (Transcriptions or Translations)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String routeName = "/";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      setState(() {
        _sharedFiles = files;
      });
    });
  }

  @override
  void dispose() {
    _dataStreamSubscription!.cancel();
    super.dispose();
  }
  //endregion

  //region Navigation
  void navigateToTranslate(BuildContext context) {
    Navigator.pushNamed(context, TranslationScreen.routeName);
  }

  void navigateToTranscription(BuildContext context) {
    Navigator.pushNamed(context, TranscriptionScreen.routeName);
  }

  void navigateToSharedTranscription(BuildContext context) {
    if (_sharedFiles?.isNotEmpty ?? false) {
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
        fontSize: 16,
      );
    }
  }
  //endregion

  Future<T?> showSupportedLanguages<T>() async {
    final Widget continueButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    final AlertDialog alert = AlertDialog(
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

    return await showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Audio list to be implemented!'),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => navigateToSharedTranscription(context),
            icon: const Icon(Icons.share_rounded),
          ),
          ActionButton(
            onPressed: () => navigateToTranscription(context),
            icon: const Icon(Icons.translate_rounded),
          ),
          ActionButton(
            onPressed: () => navigateToTranscription(context),
            icon: const Icon(Icons.transcribe_rounded),
          ),
        ],
      ),
    );
  }
}
