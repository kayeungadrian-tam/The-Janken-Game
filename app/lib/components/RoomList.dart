import 'package:app/pages/GamePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomList extends StatefulWidget {
  const RoomList({Key? key, this.stream, required this.userName})
      : super(key: key);

  final Stream<QuerySnapshot>? stream;
  final String userName;
  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _delete(roomNumber) async {
    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc("${roomNumber}")
        .delete();
  }

  Future<void> _enter(roomNumber) async {
    print("HEORHE");
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => GamePage(title: roomNumber)));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Expanded(
            child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
              return Column(children: [
                Card(
                    child: ListTile(
                  title: Center(child: Text("Round ${doc.id}")),
                  subtitle: Text("by: ${data["host"]}"),
                )),
                if (data["host"] == widget.userName)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _delete("${doc.id}"),
                        child: const Text("Delete"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.red[400]), // set the background color
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () => _enter("${doc.id}"),
                        child: const Text(
                          "Join",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.green[600]), // set the background color
                        ),
                      ),
                    ],
                  )
                else
                  Text("ELSE"),
              ]);
            }).toList()),
          );
        });
  }
}
