import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:app/components/CardTemplate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/components/Drawer.dart';

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
  int roundIdx = 0;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Random random = Random();
  int index = 0;
  int botIndex = 0;
  String userName = "Adrian";
  late List<String> tmpValue = [];
  String name = "";

  Stream<QuerySnapshot>? _usersStream;
  Stream<QuerySnapshot>? _roomsStream;
  Stream<QuerySnapshot>? _eventsStream;

  final TextEditingController _textController = TextEditingController();
  // CollectionReference reference = FirebaseFirestore.instance
  //     .collection('Rooms')
  //     .doc(widget.title)
  //     .collection("Players");

  @override
  void initState() {
    super.initState();
    _initGame();
    // setState(() {
    //   index = random.nextInt(3);
    // });

    _usersStream = FirebaseFirestore.instance
        .collection('Rooms')
        .doc(widget.title)
        .collection("Players")
        .snapshots();

    _eventsStream = FirebaseFirestore.instance
        .collection('Rooms')
        .doc(widget.title)
        .collection("Events")
        .snapshots();

    _roomsStream = FirebaseFirestore.instance.collection("Rooms").snapshots();
  }

  void refresh() async {
    setState(() {
      index = random.nextInt(3);
      botIndex = random.nextInt(3);
      roundIdx += 1;
    });
    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc("${widget.title}")
        .collection("Players")
        .doc("bot_id")
        .update({"hand": botIndex});

    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc(widget.title)
        .collection("Players")
        .doc("Adrian_id")
        .update({
      "hand": index,
    });

    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc(widget.title)
        .collection("Events")
        .doc('${DateTime.now().millisecondsSinceEpoch}')
        .set({"round": roundIdx, "${userName}": index, "bot": botIndex});
  }

  void SwitchUser() {
    setState(() {
      if (userName == "Adrian") {
        userName = "bot";
      } else {
        userName = "Adrian";
      }
      ;
    });
  }

  void _resetCollection() async {
    var collection = FirebaseFirestore.instance
        .collection('Rooms')
        .doc(widget.title)
        .collection("Events");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  void _initGame() async {
    _resetCollection();
    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc(widget.title)
        .collection("Deck")
        .doc(userName)
        .set({
      "deck": [7, 7, 7]
    });
    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc(widget.title)
        .collection("Events")
        .doc('${DateTime.now().millisecondsSinceEpoch}')
        .set({"round": roundIdx, "${userName}": index, "bot": botIndex});
    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc(widget.title)
        .collection("Players")
        .doc("bot_id")
        .set({"name": "bot", "hand": 0});
    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc(widget.title)
        .collection("Players")
        .doc("Adrian_id")
        .set({"name": "Adrian", "hand": 0});
  }

  void _createRoom() async {
    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc(widget.title)
        .set({"createdAt": DateTime.now().millisecondsSinceEpoch});
    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc(widget.title)
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
                            children: <Widget>[
                              Flexible(
                                fit: FlexFit.loose,
                                // child: SizedBox(
                                // height: 400,
                                child: Row(
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
                                  // ),
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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: refresh,
            ),
            Center(
                child: Text(widget.title +
                    "${_firebaseAuth.currentUser?.displayName}")),
            IconButton(onPressed: _signOut, icon: Icon(Icons.logout))
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(child: MyDrawer(stream: _usersStream)),
      body: DocsFromFirestore(),
      floatingActionButton:
          ElevatedButton(onPressed: SwitchUser, child: Text("switch")),
    );
  }
}
