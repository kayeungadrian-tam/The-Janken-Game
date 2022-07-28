import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key, this.stream}) : super(key: key);

  final Stream<QuerySnapshot>? stream;

  @override
  State<MyDrawer> createState() => _DrawerState();
}

class _DrawerState extends State<MyDrawer> {
  Stream<QuerySnapshot>? _usersStream;

  final cards = ["✋", "✊", "✌"];

  final tstyle =
      TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();

    _usersStream = FirebaseFirestore.instance
        .collection('Rooms')
        .doc("404")
        .collection("Events")
        .snapshots();
  }

  static const drawerHeader = UserAccountsDrawerHeader(
    accountName: Text('User Name'),
    accountEmail: Text('user.name@email.com'),
    currentAccountPicture: CircleAvatar(
      backgroundColor: Colors.white,
      child: FlutterLogo(size: 42.0),
    ),
    otherAccountsPictures: <Widget>[
      CircleAvatar(
        backgroundColor: Colors.yellow,
        child: Text('A'),
      ),
      CircleAvatar(
        backgroundColor: Colors.red,
        child: Text('B'),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
            return Column(children: [
              Card(
                  child: ListTile(
                      title: Center(child: Text("Round ${data['round']}")))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Adrian",
                      ),
                      Text(
                        cards[data['Adrian']],
                        style: tstyle,
                      ),
                    ],
                  ),
                  const Text("VS"),
                  Column(
                    children: [
                      Text("bot"),
                      Text(cards[data['bot']], style: tstyle),
                    ],
                  )
                ],
              )

              //   Card(
              //       child: ListTile(
              //     title:    Text("Adrian"),
              //     subtitle: Text(cards[data['Adrian']]),
              //   )),
              //   Card(
              //       child: ListTile(
              //     title: Text("bot"),
              //     subtitle: Text(cards[data['bot']]),
              //   )),
              // ],
            ]);
          }).toList());
        });
  }
}
