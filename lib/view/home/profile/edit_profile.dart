import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/services/database.dart';
import 'package:smart_home/widgets/show_photo.dart';
import 'package:smart_home/widgets/widgets.dart';

import '../../../models/users.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isSelected = false;
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final picker = ImagePicker();
  File? file;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final id = auth.user!.uid;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: fontColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                showPhoto(db, id, file),
                bottomSheet(context, id),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Text(
                    "Username",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
                showUserName(db, id),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Text(
                    "E-mail",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
                showEmail(db, id),
                const SizedBox(height: 30),
                editButton(id, auth, db, context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector editButton(
      String id, AuthBase auth, Database db, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          _upload(id);
        }
        try {
          auth.updateEmail(emailController.text);
          db.updateProfile(
            uId: id,
            name: nameController.text,
            email: emailController.text,
          );
          Navigator.pop(context);
        } on FirebaseAuthException catch (e) {
          showAlertDialog(
            context,
            title: "Sign Up",
            content: e.code,
            defaultActionText: "OK",
          );
          debugPrint(e.toString());
        }
      },
      child: Center(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    "Save Profile",
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
    );
  }

  GestureDetector bottomSheet(BuildContext context, String id) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Wrap(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _fromCamera();
                  },
                  //_fromCamera,
                  leading: const Icon(Icons.camera),
                  title: const Text('Take a photo'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    // _fromGallery();
                    selectFile(id);
                  },
                  leading: const Icon(Icons.image),
                  title: const Text('Choose from gallery'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _remove(id);
                  },
                  leading: const Icon(Icons.delete_rounded),
                  title: const Text('Remove photo'),
                ),
              ],
            );
          },
        );
      },
      child: Center(
        child: Text("Change Profile Photo",
            style: TextStyle(
              color: Colors.blue.shade300,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  Widget showUserName(Database db, String id) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Row(
        children: <Widget>[
          StreamBuilder<Users?>(
            stream: db.getUser(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                nameController.text = snapshot.data!.name;
                return Expanded(
                  child: TextFormField(
                    controller: nameController,
                    validator: validateName,
                  ),
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

  Widget showEmail(Database db, String id) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Row(
        children: <Widget>[
          StreamBuilder<Users?>(
            stream: db.getUser(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                emailController.text = snapshot.data!.email;
                return Expanded(
                  child: TextFormField(
                    enabled: false,
                    validator: validateEmail,
                    controller: emailController,
                  ),
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

  _upload(String id) async {
    final database = Provider.of<Database>(context, listen: false);
    var imageFile =
        FirebaseStorage.instance.ref().child("profileImage").child(id);
    UploadTask task = imageFile.putFile(file!);
    TaskSnapshot snapshot = await task;
    String url = await snapshot.ref.getDownloadURL();
    database.addImage(uId: id, url: url);
  }

  Future<void> selectFile(String id) async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        file = File(pickedImage.path);
        isSelected = true;
      }
    });
  }

  void _remove(String id) async {
    final database = Provider.of<Database>(context, listen: false);

    try {
      database.removeImage(uId: id);
      await FirebaseStorage.instance
          .ref()
          .child("profileImage")
          .child(id)
          .delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _fromCamera() async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedImage != null) {
        file = File(pickedImage.path);
        isSelected = true;
      }
    });
  }
}
