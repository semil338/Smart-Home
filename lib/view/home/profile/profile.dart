import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_home/view/home/profile/edit_profile.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/services/database.dart';
import 'package:smart_home/widgets/custom_shape.dart';

import '../../../models/users.dart';
import '../../../widgets/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ImageProvider img = const AssetImage("assets/images/forget_pass.jpg");

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final id = Provider.of<AuthBase>(context, listen: false).user!.uid;

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: fontColor,
          elevation: 0,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25.h,
                  child: Stack(
                    children: [
                      ClipPath(
                        clipper: CustomShape(),
                        child: Container(
                          height: 150,
                          color: fontColor,
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            StreamBuilder<Users?>(
                                stream: db.getUser(id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFFecf5fb),
                                            width: 2,
                                          ),
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFecf5fb),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: CircleAvatar(
                                            backgroundColor: Color(0xFFecf5fb),
                                            backgroundImage: AssetImage(
                                                "assets/images/user.png"),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFFecf5fb),
                                            width: 2,
                                          ),
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFecf5fb),
                                        ),
                                        child: Padding(
                                          padding:
                                              snapshot.data!.photoURL.isNotEmpty
                                                  ? const EdgeInsets.all(0)
                                                  : const EdgeInsets.all(18.0),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color(0xFFecf5fb),
                                            backgroundImage: snapshot
                                                    .data!.photoURL.isNotEmpty
                                                ? CachedNetworkImageProvider(
                                                    snapshot.data!.photoURL)
                                                : const AssetImage(
                                                    "assets/images/user.png",
                                                  ) as ImageProvider,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFFecf5fb),
                                            width: 2,
                                          ),
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFecf5fb),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: CircleAvatar(
                                            backgroundColor: Color(0xFFecf5fb),
                                            backgroundImage: AssetImage(
                                                "assets/images/user.png"),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Text(
                    "Username",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  ),
                ),
                showUserName(db),
                const Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Text(
                    "E-mail",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  ),
                ),
                showEmail(
                  db,
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfile())),
                  child: Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      borderOnForeground: false,
                      color: fontColor,
                      elevation: 5,
                      child: SizedBox(
                        height: 7.h,
                        width: 50.w,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const <Widget>[
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.2,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget showUserName(
    Database db,
  ) {
    final id = Provider.of<AuthBase>(context, listen: false).user!.uid;
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Row(
        children: <Widget>[
          StreamBuilder<Users?>(
            stream: db.getUser(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Expanded(
                  child: TextField(
                    // textAlign: TextAlign.center,
                    decoration: const InputDecoration(border: InputBorder.none),
                    enabled: false,
                    controller: TextEditingController(
                      text: snapshot.data!.name,
                    ),
                  ),
                  /*Text(
                      snapshot.data!.name,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),*/
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("");
              } else {
                return const Text("");
              }
            },
          ),
        ],
      ),
    );
  }

  Widget showEmail(
    Database db,
  ) {
    final id = Provider.of<AuthBase>(context, listen: false).user!.uid;
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Row(
        children: <Widget>[
          StreamBuilder<Users?>(
            stream: db.getUser(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Expanded(
                  child: TextField(
                    // textAlign: TextAlign.center,
                    decoration: const InputDecoration(border: InputBorder.none),
                    enabled: false,
                    controller:
                        TextEditingController(text: snapshot.data!.email),
                  ),
                  /*Text(
                      snapshot.data!.name,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),*/
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("");
              } else {
                return const Text("");
              }
            },
          ),
        ],
      ),
    );
  }
}
