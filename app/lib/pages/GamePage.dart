import 'package:flutter/material.dart';
import 'dart:math';
import 'package:app/components/CardTemplate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool isActive = false;
  int index = 0;
  Random random = Random();
  String userName = "Adrian";
  late List<String> tmpValue = [];
  String name = "";

  Stream<QuerySnapshot>? _usersStream;

  Stream<QuerySnapshot>? _roomsStream;

  final TextEditingController _textController = TextEditingController();
  CollectionReference reference = FirebaseFirestore.instance
      .collection('Rooms')
      .doc("404")
      .collection("Players");

  @override
  void initState() {
    super.initState();
    _initGame();
    setState(() {
      index = random.nextInt(3);
    });

    _usersStream = FirebaseFirestore.instance
        .collection('Rooms')
        .doc("404")
        .collection("Players")
        .snapshots();

    _roomsStream = FirebaseFirestore.instance.collection("Rooms").snapshots();
  }

  void SwitchUser() {
    setState(() {
      if (userName == "Adrian") {
        userName = "bot";
      } else {
        userName = "Adrian";
      }
      ;
      // isActive = !isActive;
    });
  }

  void _initGame() async {
    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc("404")
        .collection("Deck")
        .doc(userName)
        .set({
      "deck": [7, 7, 7]
    });
  }

  void _createRoom() async {
    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc("404")
        .set({"createdAt": DateTime.now().millisecondsSinceEpoch});
    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc("404")
        .collection("Players")
        .doc("${userName}_id")
        .set({"name": "${userName}"});
    // setState(() {
    // name = "";
    // });
    // _controller.clear();
  }

  Widget DocsFromFirestore() {
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: double.infinity,
              ),
              // width: 500,
              // height: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot doc) {
                          Map<String, dynamic> data =
                              doc.data()! as Map<String, dynamic>;
                          return Column(
                            mainAxisAlignment: data["name"] == userName
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: data["name"] == userName
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Align(
                                // alignment: data["name"] == userName
                                // ? Alignment.topLeft
                                // : Alignment.topRight,
                                child: Row(
                                  // mainAxisAlignment: data["name"] == userName
                                  // ? MainAxisAlignment.start
                                  // : MainAxisAlignment.end,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    data["name"] == userName
                                        ? Row(children: [
                                            PlayingCard(
                                              index: data["hand"],
                                              isOpponent:
                                                  data["name"] != userName,
                                            ),
                                            Text('${data["name"]}'),
                                          ])
                                        : Row(children: [
                                            Text('${data["name"]}'),
                                            PlayingCard(
                                              index: data["hand"],
                                              isOpponent:
                                                  data["name"] != userName,
                                            ),
                                          ]),
                                  ],
                                ),
                              ),
                            ],
                          );
                        })
                        .toList()
                        .cast(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(child: Text(widget.title + userName)),
        backgroundColor: Colors.transparent,
      ),
      body: DocsFromFirestore(),
      floatingActionButton:
          ElevatedButton(onPressed: SwitchUser, child: Text("switch")),
    );
  }
}
