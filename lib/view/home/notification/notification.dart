import 'package:flutter/material.dart';
import 'package:smart_home/widgets/widgets.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: fontColor),
      ),
      backgroundColor: const Color(0xFFecf5fb),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
              child: Icon(
            Icons.notifications_sharp,
            size: 200,
            color: fontColor.withOpacity(0.8),
          )),
          const Text(
            "Nothing here!!!",
            style: TextStyle(
                color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
