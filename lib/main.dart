import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Notification> notificationList = [];
  StreamSubscription<Event>? updates, removed;

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  void dispose() {
    updates!.cancel();
    removed!.cancel();
    super.dispose();
  }

  void readData() {
    updates = databaseReference.child('Admin').onChildAdded.listen((data) {
      notificationList.add(Notification.fromFireBase(data.snapshot));
      setState(() {});
    });
    removed = databaseReference.child('Admin').onChildRemoved.listen((data) {
      notificationList.removeAt(0);
      setState(() {});
    });
  }

  void _createData() {
    databaseReference
        .child("Admin")
        .child("Admin-1")
        .set({'name': 'Semil Kheda', 'description': 'Team Lead'}).asStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(notificationList.length.toString()),
            Expanded(
              child: FirebaseAnimatedList(
                query: databaseReference.child('Admin'),
                itemBuilder: (context, snapshot, animation, index) {
                  return Text(snapshot.value['name']);
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createData,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Notification {
  String? name;
  String? user;

  Notification.fromFireBase(DataSnapshot snapshot) {
    name = snapshot.value["name"] ?? 'Unknown user';
    user = snapshot.value["user"] ?? '';
  }
}
