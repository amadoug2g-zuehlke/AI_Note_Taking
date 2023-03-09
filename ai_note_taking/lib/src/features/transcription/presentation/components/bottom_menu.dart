import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomMenu extends StatelessWidget {
  BottomMenu({
    super.key,
    required this.selectedFile,
    required this.selectedFileName,
    required this.textButtonFunction,
    required this.iconButtonFunction,
  });

  final File selectedFile;
  final String selectedFileName;
  Future<void> Function() textButtonFunction;
  Future<void> Function() iconButtonFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () async {
              print('object');
              () => textButtonFunction;
              print('object2');
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
                () => iconButtonFunction;
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
