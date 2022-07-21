import 'package:flutter/material.dart';

class MyCard extends StatefulWidget {
  const MyCard({Key? key, required this.text}) : super(key: key);
  // MyCard(String s, {this.text});

  final String text;

  @override
  State<MyCard> createState() => _CardState();
}

class _CardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 150,
            width: 100,
            color: Colors.grey,
            child: Text("${widget.text}"),
          ),
        ));
  }
}
