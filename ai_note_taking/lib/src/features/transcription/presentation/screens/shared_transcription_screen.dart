import 'dart:async';
import 'package:ai_note_taking/src/features/transcription/data/service/transcription_request.dart';
import 'package:ai_note_taking/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class SharedTranscriptionScreen extends StatefulWidget {
  const SharedTranscriptionScreen({Key? key}) : super(key: key);

  static String navSharedTranslationScreen = "/shared_transcription";

  @override
  State<SharedTranscriptionScreen> createState() =>
      _SharedTranscriptionScreenState();
}

class _SharedTranscriptionScreenState extends State<SharedTranscriptionScreen> {
  //region Variables
  late StreamSubscription? _dataStreamSubscription;
  late String _fileName = noFileSelectedText;

  List<SharedMediaFile>? _sharedFiles;
  String _text = 'Waiting for shared transcription...';
  bool isLoading = false;
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

  //region File Transcription
  void transcriptionFromSharedFile() {
    String filePath = _sharedFiles!.first.path;

    displayTranscription(filePath);
    displaySelectedFile(filePath.substring(filePath.lastIndexOf('/') + 1));
  }

  void displayTranscription(String path) async {
    TranscriptionRequest transcriptionModel =
        TranscriptionRequest(requestFilePath: path);

    var result = await transcriptionModel.getTranscription(path);

    setState(() {
      _text = result.text;
      isLoading = false;
      _fileName = 'No file selected';
      //_sharedFiles = null;
    });
  }

  void displaySelectedFile(fileName) {
    setState(() {
      _fileName = fileName;
    });
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared file transcription'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: SingleChildScrollView(
                child: Text(
                  _text,
                  style: const TextStyle(fontSize: 20.0),
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
            margin: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_fileName),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
