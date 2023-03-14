import 'package:flutter/material.dart';

class RoundedMenuIcon extends StatelessWidget {
  const RoundedMenuIcon({
    required this.menuDestination,
    required this.menuButton,
    required this.menuDescription,
    super.key,
  });

  final Icon menuButton;
  final String menuDescription;
  final String menuDestination;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, menuDestination);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            child: menuButton,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 250,
          child: Text(
            menuDescription,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
