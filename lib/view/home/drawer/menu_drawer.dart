import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_home/models/users.dart';
import 'package:smart_home/view/home/profile/profile.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/services/database.dart';
import 'package:smart_home/view/home/drawer/menu_item.dart';
import 'package:smart_home/view/home/notification/notification.dart';
import 'package:smart_home/view/home/select_device/select_device.dart';
import 'package:smart_home/widgets/show_alert_dialog.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final id = Provider.of<AuthBase>(context, listen: false).user!.uid;

    return Scaffold(
      body: SafeArea(
        child: Theme(
          data: ThemeData.dark(),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: const [0.3, 0.5, 1],
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade400,
                  Colors.teal.shade100,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<Users?>(
                          stream: db.getUser(id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFecf5fb),
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFecf5fb),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xFFecf5fb),
                                      backgroundImage:
                                          AssetImage("assets/images/user.png"),
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.active) {
                              // return CircleAvatar(
                              //   maxRadius: 40,
                              //   // radius: 40,
                              //   backgroundColor: const Color(0xFFecf5fb),
                              //   backgroundImage:
                              //       snapshot.data!.photoURL.isNotEmpty
                              //           ? CachedNetworkImageProvider(
                              //               snapshot.data!.photoURL)
                              //           : null,
                              //   child: snapshot.data!.photoURL.isEmpty
                              //       ? const Icon(
                              //           Icons.account_circle,
                              //           size: 40,
                              //           color: fontColor,
                              //         )
                              //       : null,
                              // );
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFecf5fb),
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFecf5fb),
                                  ),
                                  child: Padding(
                                    padding: snapshot.data!.photoURL.isNotEmpty
                                        ? const EdgeInsets.all(0)
                                        : const EdgeInsets.all(12.0),
                                    child: CircleAvatar(
                                      backgroundColor: const Color(0xFFecf5fb),
                                      backgroundImage:
                                          snapshot.data!.photoURL.isNotEmpty
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
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFecf5fb),
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFecf5fb),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xFFecf5fb),
                                      backgroundImage:
                                          AssetImage("assets/images/user.png"),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                      showUserName(db, context)
                    ],
                  ),
                ),
                ...MenuItems.all
                    .map((item) => buildMenuItem(item, context))
                    .toList(),
                ListTile(
                  selectedColor: Colors.white,
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  minLeadingWidth: 20,
                  leading: const Icon(Icons.logout),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                        fontFamily: GoogleFonts.montserrat().fontFamily),
                  ),
                  onTap: () => _signOut(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signOut(BuildContext context) async {
    final result = await showAlertDialog(
      context,
      title: "Logout",
      content: "Are you sure want to logout?",
      defaultActionText: "OK",
      cancelActionText: "Cancel",
    );
    if (result) {
      final auth = Provider.of<AuthBase>(context, listen: false);
      try {
        auth.signOut();
      } on FirebaseAuthException catch (e) {
        showAlertDialog(
          context,
          title: "Error",
          content: e.message.toString(),
          defaultActionText: "OK",
        );
      }
    }
  }

  Widget showUserName(Database db, BuildContext context) {
    final id = Provider.of<AuthBase>(context, listen: false).user!.uid;
    return StreamBuilder<Users?>(
      stream: db.getUser(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                snapshot.data!.name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        } else {
          return const Text("");
        }
      },
    );
  }

  Widget buildMenuItem(MenuItem item, BuildContext context) => ListTileTheme(
        child: ListTile(
          selectedColor: Colors.white,
          iconColor: Colors.white,
          textColor: Colors.white,
          minLeadingWidth: 20,
          leading: Icon(item.icon),
          title: Text(
            item.title,
            style: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily),
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => item.onTap,
              )),
        ),
      );
}

class MenuItems {
  static const profile = MenuItem('Profile', Icons.person, Profile());
  static const devices = MenuItem('Devices', Icons.devices, SelectDevice());
  static const notifications =
      MenuItem('Notifications', Icons.notifications, Notifications());

  static const all = <MenuItem>[
    profile,
    devices,
    notifications,
  ];
}
