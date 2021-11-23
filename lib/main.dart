import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/landing.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/services/database.dart';
import 'package:smart_home/view/intro_screen/intro_screen.dart';

int? isViewed;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  isViewed = pref.getInt("onBoard");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>(create: (context) => Auth()),
        Provider<Database>(create: (context) => PersonalDatabase()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Smart Home",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isViewed != 0 ? const IntroScreen() : const LandingPage(),
      ),
    );
  }
}
