import 'package:flutter/material.dart';

class TranscriptionSettingsScreen extends StatelessWidget {
  const TranscriptionSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                //newTaskTitle = newText;
              },
            ),
            TextButton(
              onPressed: () {
                //Provider.of<TaskData>(context).addTask(newTaskTitle);
                Navigator.pop(context);
              },
              style:
                  TextButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
