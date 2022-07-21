import 'package:flutter/material.dart';

class CardBack extends StatelessWidget {
  final image_path;

  CardBack({this.image_path});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 150,
            width: 100,
            color: Colors.red,
            child: Image(
              image: AssetImage(image_path),
              fit: BoxFit.fill,
            ),
          ),
        ));
  }
}
