import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

import 'package:app/components/CardBack.dart';
import 'package:app/components/CardTemplate.dart';

import '../components/Card.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _counter = 0;
  bool isActive = false;

  void SwitchUser() {
    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment:
                isActive ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: <Widget>[
              PlayingCard(),
            ],
          ),
        ),
      ),
      floatingActionButton:
          ElevatedButton(onPressed: SwitchUser, child: Text("switch")),
    );
  }
}
