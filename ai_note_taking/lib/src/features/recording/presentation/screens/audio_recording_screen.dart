import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecordingScreen extends StatefulWidget {
  const AudioRecordingScreen({Key? key}) : super(key: key);

  @override
  State<AudioRecordingScreen> createState() => _AudioRecordingScreenState();
}

class _AudioRecordingScreenState extends State<AudioRecordingScreen> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  //TODO: Create a variable to store the path of the recording

  @override
  void initState() {
    super.initState();

    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();

    super.dispose();
  }

  void initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();

    isRecorderReady = true;

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );
  }

  Future startRecording() async {
    if (!isRecorderReady) return;

    print('starting recording');
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stopRecording() async {
    if (!isRecorderReady) return;

    print('stopping recording');
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);

    print('Recording path: $audioFile');
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Add a button to trigger the navigation to the transcription screen, with the recording's path as an argument
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: recorder.onProgress,
              builder: (context, snapshot) {
                final duration =
                    snapshot.hasData ? snapshot.data!.duration : Duration.zero;

                String twoDigits(int n) => n.toString().padLeft(2, '0');
                final twoDigitsMinutes =
                    twoDigits(duration.inMinutes.remainder(60));
                final twoDigitsSeconds =
                    twoDigits(duration.inSeconds.remainder(60));

                return Text(
                  '$twoDigitsMinutes:$twoDigitsSeconds',
                  style: const TextStyle(fontSize: 70),
                );
              },
            ),
            const SizedBox(
              height: 132,
            ),
            ElevatedButton(
              onPressed: () async {
                if (recorder.isRecording) {
                  await stopRecording();
                } else {
                  await startRecording();
                }
              },
              child: const SizedBox(
                width: 100,
                height: 80,
                child: Icon(
                  Icons.mic_rounded,
                  size: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
