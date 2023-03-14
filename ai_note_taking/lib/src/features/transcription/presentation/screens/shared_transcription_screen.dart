import 'dart:async';
import 'package:ai_note_taking/src/features/transcription/data/service/transcription_request.dart';
import 'package:ai_note_taking/src/features/transcription/domain/model/shared_screen_arguments.dart';
import 'package:ai_note_taking/utils/constants.dart';
import 'package:flutter/material.dart';

class SharedTranscriptionScreen extends StatefulWidget {
  const SharedTranscriptionScreen({super.key});

  static String routeName = "/shared_transcription";

  @override
  State<SharedTranscriptionScreen> createState() =>
      _SharedTranscriptionScreenState();
}

class _SharedTranscriptionScreenState extends State<SharedTranscriptionScreen> {
  late SharedScreenArguments args;
  bool isLoading = false;

  //region Variables
  late StreamSubscription? _dataStreamSubscription;

  late String _fileName = noFileSelectedText;
  String _text = 'Waiting for shared transcription...';

  @override
  void dispose() {
    _dataStreamSubscription!.cancel();
    super.dispose();
  }

  //endregion

  //region Override Methods
  @override
  void initState() {
    super.initState();
  }

  //endregion

  //region File Transcription
  void transcriptionFromSharedFile() {
    setState(() {
      isLoading = true;
    });
    final String filePath = args.sharedFiles.first.path;

    displayTranscription(filePath);
    displaySelectedFile(filePath.substring(filePath.lastIndexOf('/') + 1));
  }

  void displayTranscription(String path) async {
    final TranscriptionRequest transcriptionModel =
        TranscriptionRequest(requestFilePath: path);

    final result = await transcriptionModel.getTranscription(path);

    setState(() {
      _text = result.text;
      isLoading = false;
      _fileName = 'No file selected';
    });
  }

  void displaySelectedFile(String fileName) {
    setState(() {
      _fileName = fileName;
    });
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments! as SharedScreenArguments;
    transcriptionFromSharedFile();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared file transcription'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: SingleChildScrollView(
                child: Text(
                  _text,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isLoading ? true : false,
            child: const LinearProgressIndicator(
              minHeight: 5,
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                _fileName,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.fade,
                maxLines: 3,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
