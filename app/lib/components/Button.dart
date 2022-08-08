import 'package:flutter/material.dart';

class MypButton extends StatelessWidget {
  final String title;
  final dynamic ontapp;

  MypButton({required this.title, required this.ontapp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 300,
        child: SizedBox(
          height: 45,
          child: ElevatedButton(
            onPressed: ontapp,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white30),
            ),
          ),
        ),
      ),
    );
  }
}
