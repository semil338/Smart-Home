import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/widgets/show_alert_dialog.dart';

class HomePageSignOut extends StatelessWidget {
  const HomePageSignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ElevatedButton(
          onPressed: () => _signOut(context),
          child: const Text("Sign out"),
        ),
      ),
    );
  }

  _signOut(BuildContext context) {
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
