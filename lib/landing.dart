import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/view/home/home.dart';
import 'package:smart_home/view/sign_in/sign_in.dart';
import 'package:smart_home/view/sign_in/sign_in_model.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<User?>(
      stream: auth.authChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return ChangeNotifierProvider<SignInModel>(
              create: (context) => SignInModel(auth: auth),
              child: const SignIn(),
            );
          } else {
            // return Provider<Database>(
            //   create: (context) => FirestoreDatabase(uid: user.uid),
            //   child: const HomePage(),
            // );
            return const HomePage();
          }
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
