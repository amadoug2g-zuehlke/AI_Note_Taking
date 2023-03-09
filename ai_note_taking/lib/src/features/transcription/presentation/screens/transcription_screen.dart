import 'dart:io';
import 'package:ai_note_taking/src/features/transcription/data/service/transcription_request.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as p;

//TODO: Add tests

class TranscriptionScreen extends StatefulWidget {
  const TranscriptionScreen({super.key});

  @override
  _TranscriptionScreenState createState() => _TranscriptionScreenState();
}

class _TranscriptionScreenState extends State<TranscriptionScreen> {
  //region Variables
  final audioPlayer = AudioPlayer();
  late String _selectedFileName = 'No file selected';
  late File _selectedFile;

  String _text = 'Transcription incoming...';
  bool isLoading = false;
  bool isFilePlaying = false;
  //endregion

  //region Override Methods
  @override
  void initState() {
    super.initState();

    setState(() {
      _selectedFile = File('');
    });
  }
  //endregion

  //region File Transcription
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      audioPlayer.setSourceUrl(file.path);

      if (audioPlayer.source != null) {
        displaySelectedFile(
            file.path.substring(file.path.lastIndexOf('/') + 1));
        setState(() {
          _selectedFile = file;
        });
      }
    } else {
      setState(() {
        _selectedFileName = 'No file selected';
      });
    }
  }

  void transcriptionFromLocalFile() async {
    if (await _selectedFile.length() > 25000000) {
      Fluttertoast.showToast(
          msg: "File size is over 25MB",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
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
            transcriptConfirmDialog();
            break;
          }
        default:
          {
            formatErrorDialog();
          }
      }
    }
  }

  void transcriptConfirmDialog() {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Transcribe"),
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        displayTranscription(_selectedFile.path);
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Transcription"),
      content:
          Text("Would you like to transcribe this file? ($_selectedFileName)"),
      actions: [
        cancelButton,
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

  void formatErrorDialog() {
    Widget continueButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Transcription"),
      content: const Text(
          "File format is not supported (Compatible types: .mp3, .mp4, .mpeg, .mpga, .m4a, .wav, .webm)"),
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

  void displayTranscription(String filePath) async {
    TranscriptionRequest transcriptionModel =
        TranscriptionRequest(requestFilePath: filePath);

    var result = await transcriptionModel.getTranscription(filePath);

    setState(() {
      _text = result.text;
      isLoading = false;
      _selectedFileName = 'No file selected';
    });
  }

  void displaySelectedFile(fileName) {
    setState(() {
      _selectedFileName = fileName;
    });
  }
  //endregion

  //region Audio Player
  /// Play selected file from local storage
  void playFile(source) {
    audioPlayer.play(source);
    Fluttertoast.showToast(
        msg: "File is playing",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    setState(() {
      isFilePlaying = true;
    });
  }

  /// Pause selected file
  void stopFile() {
    audioPlayer.stop();
    Fluttertoast.showToast(
        msg: "File stopped playing",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    setState(() {
      isFilePlaying = false;
    });
  }
  //endregion

  //TODO: Split screen into components
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transcription'),
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
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      pickFile();
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
                            fontSize: 16.0);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10.0),
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
