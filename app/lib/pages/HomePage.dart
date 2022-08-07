import 'package:app/pages/GamePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

import "package:app/constants/lotties.dart";

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

  Widget Tite(String room, String host) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text('Room ${room}'),
        subtitle: Text('by ${host}'),
        onTap: _enter,
      ),
    );
  }

  Widget Rooms() {
    return StreamBuilder<QuerySnapshot>(
      stream: _roomsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text('Loading...');
        return Container(
          height: 200,
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return roomNumber == document.id
                  ? Tite('${document.id}', '${document["host"]}')
                  : Text(roomNumber);
            }).toList(),
          ),
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {/* Write listener code here */},
            child: Icon(
              Icons.menu, // add custom icons also
            )),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('You have logged in Successfuly'),
            SizedBox(height: 50),
            Container(
              height: 60,
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
            const SizedBox(
              height: 100,
            ),
            Rooms(),
            ClipOval(
              child: Material(
                child: InkWell(
                    onTap: _pressed,
                    child: isLoading
                        ? Lottie.network(
                            "https://assets3.lottiefiles.com/packages/lf20_xgxirjr9.json",
                            height: 200,
                            frameRate: FrameRate(60),
                            width: 200)
                        : Lottie.asset(search,
                            height: 200, frameRate: FrameRate(60), width: 200)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
