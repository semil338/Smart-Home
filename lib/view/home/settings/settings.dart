import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_home/models/users.dart';
import 'package:smart_home/services/database.dart';
import 'package:smart_home/view/home/profile/profile.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/view/sign_in/forget_password.dart';
import 'package:smart_home/widgets/widgets.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final id = Provider.of<AuthBase>(context, listen: false).user!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: fontColor),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
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
                      showUserName(db, context),
                    ],
                  ),
                ),
                const Divider(color: fontColor),
                const SizedBox(height: 10),
                settingListName("Account"),
                settingListTile(
                  'Edit Profile',
                  Icons.account_circle,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile())),
                ),
                settingListTile(
                  'Change Password',
                  Icons.lock,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgetPassword())),
                ),
                settingListTile(
                  'Sign out',
                  Icons.logout,
                  () => _signOut(context),
                ),
                const SizedBox(height: 10),
                settingListName("Other"),
                settingListTile('Rate us', Icons.star, () {}),
                settingListTile('Feedback', Icons.edit, () {}),
                settingListTile('Report Problem', Icons.shield, () {}),
                settingListTile('About us', Icons.info_rounded, () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          bodyImage(context),
                          const Text(
                            "Smart Home is used to control Home Appliances and Sensors from anywhere in the world.",
                            textAlign: TextAlign.justify,
                            // style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Contact Us :",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "smarthome.sdp@gmail.com",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(55, 59, 94, 1))),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/icon.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  ListTile settingListTile(String text, IconData icon, Function()? onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: fontColor),
      title: Text(text),
    );
  }

  Widget settingListName(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(color: kPrimaryColor),
      ),
    );
  }

  Widget showUserName(Database db, BuildContext context) {
    final id = Provider.of<AuthBase>(context, listen: false).user!.uid;
    return StreamBuilder<Users?>(
      stream: db.getUser(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  snapshot.data!.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: fontColor,
                  ),
                ),
                Text(
                  snapshot.data!.email,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w200,
                    color: fontColor,
                  ),
                ),
              ],
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
}
