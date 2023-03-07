import 'dart:io';
import 'package:ai_note_taking/src/features/transcription/data/service/transcription.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordingScreen extends StatelessWidget {
  const RecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech to Text App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //region Variables
  final audioPlayer = AudioPlayer();
  final recorder = FlutterSoundRecorder();

  late String _recordingPath;
  late AnimationController controller;

  String _text = 'Transcription incoming...';
  bool isLoading = false;
  bool isRecorderReady = false;
  bool isFilePlaying = false;
  //endregion

  //region Override Methods
  @override
  void initState() {
    super.initState();
    initRecorder();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    controller.dispose();
    super.dispose();
  }
  //endregion

  //region Audio Recording
  void initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    //await recorder.startRecorder();

    isRecorderReady = true;

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  void startRecording() async {
    if (!isRecorderReady) return;

    await recorder.startRecorder(toFile: 'audio');
  }

  void stopRecording() async {
    if (!isRecorderReady) return;

    final path = await recorder.stopRecorder();
    //final audioFile = File(path!);

    File file = File(await getFilePath(path!));

    _recordingPath = file.path;
    print('Recording path: $_recordingPath');
  }

  Future<String> getFilePath(String audioFile) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/$audioFile';

    return filePath;
  }
  //endregion

  //region File Transcription
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mp4', 'mpeg', 'mpga', 'm4a', 'wav', 'webm'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      audioPlayer.setSourceUrl(file.path);

      if (audioPlayer.source != null) {
        //playFile(audioPlayer.source);
        TranscriptionModel transcriptionModel = TranscriptionModel();
        isLoading = true;
        var result = await transcriptionModel.getTranscription(file.path);
        displayTranscription(result.text);
      }
    }
  }

  //Displays file transcription
  void displayTranscription(String transcription) {
    setState(() {
      _text = transcription;
      isLoading = false;
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
    isFilePlaying = true;
  }

  /// Play file from assets folder
  void play() async {
    final player = AudioCache(prefix: 'assets/');
    final url = await player.load('audio_sample_002.mp3');
    audioPlayer.setSourceUrl(url.path);
    isFilePlaying = true;
  }

  /// Pause stop file
  void stopFile() {
    audioPlayer.stop();
    Fluttertoast.showToast(
        msg: "File stopped playing",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    isFilePlaying = false;
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text App'),
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
                AvatarGlow(
                  endRadius: 50.0,
                  glowColor: Colors.redAccent,
                  child: FloatingActionButton(
                    onPressed: () {
                      print(_text);
                      /*
                      if (recorder.isRecording) {
                        stopRecording();
                      } else {
                        startRecording();
                      }
                      */
                    },
                    backgroundColor: Colors.red,
                    child: Icon(recorder.isRecording ? Icons.stop : Icons.mic),
                  ),
                ),
                /*
                GestureDetector(
                    onTap: () {
                      pauseFile();
                    },
                    child: const Icon(
                      Icons.stop_circle_rounded,
                      size: 35,
                    )),
                */
                ElevatedButton(
                  onPressed: () {
                    stopFile();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10.0),
                    backgroundColor: Colors.blue,
                    foregroundColor: isFilePlaying ? Colors.red : Colors.white,
                  ),
                  child: const Icon(Icons.stop_rounded),
                ),
                StreamBuilder(
                  stream: recorder.onProgress,
                  builder: (context, snapshot) {
                    final duration = snapshot.hasData
                        ? snapshot.data!.duration
                        : Duration.zero;

                    String twoDigits(int n) => n.toString().padLeft(2, '0');
                    final twoDigitsMinutes =
                        twoDigits(duration.inMinutes.remainder(60));
                    final twoDigitsSeconds =
                        twoDigits(duration.inSeconds.remainder(60));

                    return Text(
                      '$twoDigitsMinutes:$twoDigitsSeconds',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    );
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    pickFile();
                  },
                  icon: const Icon(Icons.folder),
                  label: const Text('Select File'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
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
