import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({
    required this.selectedFile,
    required this.selectedFileName,
    required this.textButtonFunction,
    required this.iconButtonFunction,
    super.key,
  });

  final Future<void> Function() iconButtonFunction;
  final File selectedFile;
  final String selectedFileName;
  final Future<void> Function() textButtonFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () async {
              debugPrint('object');
              // what? () => textButtonFunction;
              debugPrint('object2');
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
              if (selectedFile.path.isNotEmpty) {
                // what? () => iconButtonFunction;
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
              backgroundColor:
                  selectedFile.path.isEmpty ? Colors.grey : Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Icon(Icons.transcribe_rounded),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              selectedFileName,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.fade,
              maxLines: 3,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}
