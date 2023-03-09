import 'package:flutter/material.dart';

class LoadingBar extends StatelessWidget {
  const LoadingBar({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading ? true : false,
      child: const LinearProgressIndicator(
        minHeight: 5,
      ),
    );
  }
}
