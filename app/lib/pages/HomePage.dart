import 'package:app/components/Button.dart';
import 'package:app/components/RoomList.dart';
import 'package:app/pages/GamePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

import "package:app/constants/lotties.dart";
import 'package:app/components/Drawer.dart';

const inputStyle = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  labelStyle:
      TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  focusedBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Colors.white, width: 2, style: BorderStyle.solid),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Colors.white, width: 2, style: BorderStyle.solid),
  ),
);

const hintstyle = TextStyle(color: Colors.white60, fontStyle: FontStyle.italic);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<QuerySnapshot>? _roomsStream;

  bool isLoading = false;
  String roomNumber = "";

  void _enter() {
    print("HEORHE");
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => GamePage(title: roomNumber)));
  }

  @override
  void initState() {
    super.initState();
    _roomsStream = FirebaseFirestore.instance.collection("Rooms").snapshots();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = SnackBar(
        content: Text('Welcome ${_firebaseAuth.currentUser?.displayName}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Logged out.'),
    ));
  }

  void _pressed() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void _addRoom() async {
    if (roomNumber != "")
      await FirebaseFirestore.instance
          .collection("Rooms")
          .doc("${roomNumber}")
          .set({
        "host": "${_firebaseAuth.currentUser?.displayName}",
        "createAt": DateTime.now().toUtc()
      });
    else
      print("ELSE");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: GestureDetector(
        //     onTap: () {/* Write listener code here */},
        //     child: Icon(
        //       Icons.menu, // add custom icons also
        //     )),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: _signOut,
                child: Icon(Icons.logout),
              )),
        ],
        title: Center(child: Text("Home")),
        backgroundColor: Colors.transparent,
      ),
      // backgroundColor: Colors.grey[200],
      drawer: Drawer(child: MyDrawer(stream: _roomsStream)),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoomList(
                  stream: _roomsStream,
                  userName: "${_firebaseAuth.currentUser?.displayName}"),
              Divider(),
              Container(
                // height: 60,
                width: 300,
                child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      roomNumber = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email";
                      } else {
                        print("HERE");
                      }
                    },
                    textAlign: TextAlign.center,
                    decoration: inputStyle.copyWith(
                      hintText: "Room number",
                      hintStyle: hintstyle,
                      prefixIcon: const Icon(
                        Icons.door_front_door,
                        color: Colors.white,
                      ),
                    )),
              ),
              MypButton(ontapp: _addRoom, title: "Add"),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
