import 'dart:async';
import 'package:ai_note_taking/src/features/transcription/data/service/transcription_request.dart';
import 'package:ai_note_taking/src/features/transcription/domain/model/shared_screen_arguments.dart';
import 'package:ai_note_taking/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class SharedTranscriptionScreen extends StatefulWidget {
  const SharedTranscriptionScreen({Key? key}) : super(key: key);
  static String routeName = "/shared_transcription";

  @override
  State<SharedTranscriptionScreen> createState() =>
      _SharedTranscriptionScreenState();
}

class _SharedTranscriptionScreenState extends State<SharedTranscriptionScreen> {
  //region Variables
  late StreamSubscription? _dataStreamSubscription;
  late String _fileName = noFileSelectedText;
  late SharedScreenArguments args;

  String _text = 'Waiting for shared transcription...';
  bool isLoading = false;
  //endregion

  //region Override Methods
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dataStreamSubscription!.cancel();
    super.dispose();
  }
  //endregion

  //region File Transcription
  void transcriptionFromSharedFile() {
    setState(() {
      isLoading = true;
    });
    String filePath = args.sharedFiles.first.path;

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
    args = ModalRoute.of(context)!.settings.arguments as SharedScreenArguments;
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
            height: 40,
            margin: const EdgeInsets.all(16.0),
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
            /*
            ElevatedButton(
                  onPressed: () {
                    if (args.sharedFiles.first.path.isNotEmpty) {
                      transcriptionFromSharedFile();
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
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10.0),
                    backgroundColor: args.sharedFiles.first.path.isEmpty
                        ? Colors.grey
                        : Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.transcribe_rounded),
                ),
             */
          ),
        ],
      ),
    );
  }
}
