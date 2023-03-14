import 'dart:io';

import 'package:ai_note_taking/src/features/transcription/presentation/components/loading_bar.dart';
import 'package:ai_note_taking/src/features/transcription/presentation/components/transcription_box.dart';
import 'package:ai_note_taking/src/features/translation/data/service/translation_request.dart';
import 'package:ai_note_taking/src/features/translation/domain/model/translation_response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as p;

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  static String routeName = "/translation";

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  bool isFilePlaying = false;
  bool isLoading = false;

  late File _selectedFile;
  //region Variables
  late String _selectedFileName;

  String _text = 'Waiting for file to translate...';

  //endregion

  //region Override Methods
  @override
  void initState() {
    super.initState();

    resetFile();
  }

  //endregion

  //region File Transcription
  Future<void> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final File file = File(result.files.single.path!);

      displaySelectedFile(file.path.substring(file.path.lastIndexOf('/') + 1));
      setState(() {
        _selectedFile = file;
      });
    } else {
      resetFile();
    }
  }

  Future<void> transcriptionFromLocalFile() async {
    if (await _selectedFile.length() > 25000000) {
      await Fluttertoast.showToast(
        msg: "File size is over 25MB",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16,
      );
    } else {
      switch (p.extension(_selectedFile.path)) {
        case '.mp3':
        case '.mp4':
        case '.mpeg':
        case '.mpga':
        case '.m4a':
        case '.wav':
        case '.webm':
          {
            return await transcriptConfirmDialog();
          }
        default:
          {
            return await formatErrorDialog();
          }
      }
    }
  }

  Future<T?> transcriptConfirmDialog<T>() async {
    final Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    final Widget continueButton = TextButton(
      child: const Text("Transcribe"),
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        displayTranscription(_selectedFile.path);
        Navigator.of(context).pop();
      },
    );

    final AlertDialog alert = AlertDialog(
      title: const Text("Transcription & translation"),
      content: Text(
        "Would you like to transcribe and translate this file to english? ($_selectedFileName)",
      ),
      actions: [
        cancelButton,
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

  Future<T?> formatErrorDialog<T>() async {
    final Widget continueButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        resetFile();
        Navigator.of(context).pop();
      },
    );

    final AlertDialog alert = AlertDialog(
      title: const Text("Transcription"),
      content: const Text(
        "File format is not supported (Compatible types: .mp3, .mp4, .mpeg, .mpga, .m4a, .wav, .webm)",
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

  Future<void> displayTranscription(String filePath) async {
    final TranslationRequest transcriptionModel =
        TranslationRequest(requestFilePath: filePath);

    final TranslationResponse result =
        await transcriptionModel.getTranslation(filePath);

    setState(() {
      _text = result.text;
      isLoading = false;
      _selectedFileName = 'No file selected';
    });
  }

  void displaySelectedFile(String fileName) {
    setState(() {
      _selectedFileName = fileName;
    });
  }

  void resetFile() {
    setState(() {
      _selectedFile = File('');
      _selectedFileName = 'No file selected';
    });
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TranscriptionBox(text: _text),
          LoadingBar(isLoading: isLoading),
          Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await pickFile();
                    },
                    icon: const Icon(Icons.folder),
                    label: const Text('Select File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedFile.path.isNotEmpty) {
                        transcriptionFromLocalFile();
                      } else {
                        Fluttertoast.showToast(
                          msg: "No file selected",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      backgroundColor: _selectedFile.path.isEmpty
                          ? Colors.grey
                          : Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Icon(Icons.transcribe_rounded),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      _selectedFileName,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                      maxLines: 3,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
