import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/landing.dart';
import 'package:smart_home/widgets/constant.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  _storeOnBoardInfo() async {
    int isViewed = 0;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("onBoard", isViewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IntroductionScreen(
          globalBackgroundColor: Colors.white,
          pages: [
            PageViewModel(
              title: "Smart Home App",
              decoration: _pageDecoration(),
              body: "You are few click away to enter the world of smart home.",
              image: _image("assets/images/img-1.jpg"),
            ),
            PageViewModel(
              title: "Set Up Device Easily",
              body:
                  "Link your home device by plugging them and connected to Wi-Fi.Control them all using smart home app",
              image: _image("assets/images/img-2.jpg"),
              decoration: _pageDecoration(),
            ),
            PageViewModel(
              decoration: _pageDecoration(),
              title: "Get Notified",
              body:
                  "You can get all info about your devices and the home screen and get notification For any activity or alert",
              image: _image("assets/images/img-3.jpg"),
            ),
          ],
          dotsDecorator: const DotsDecorator(
            spacing: EdgeInsets.all(5),
            activeSize: Size.square(10),
            size: Size.square(5),
            activeColor: fontColor,
          ),
          // animationDuration: 500,
          curve: Curves.fastOutSlowIn,
          showSkipButton: true,
          showNextButton: true,
          nextFlex: 1,
          dotsFlex: 1,
          skipFlex: 1,
          done: _buttons(
            widget: Center(
              child: Text(
                "Done",
                style: _style(),
              ),
            ),
          ),
          next: _buttons(
            widget: const Icon(
              Icons.navigate_next,
              size: 30,
              color: fontColor,
            ),
            colors: Colors.white,
          ),
          skip: _buttons(
            widget: Center(
              child: Text(
                "Skip",
                style: _style(),
              ),
            ),
          ),
          onDone: () async {
            await _storeOnBoardInfo();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LandingPage(),
              ),
            );
          },
          onSkip: () async {
            await _storeOnBoardInfo();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LandingPage(),
              ),
            );
          },
        ),
      ),
    );
  }

  PageDecoration _pageDecoration() {
    return PageDecoration(
      imagePadding: const EdgeInsets.all(24),
      descriptionPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontFamily: GoogleFonts.ubuntu().fontFamily,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.grey.shade500,
        fontFamily: GoogleFonts.ubuntu().fontFamily,
      ),
    );
  }

  Widget _image(String path) {
    return Center(
        child: Image.asset(
      path,
      width: 350,
    ));
  }

  TextStyle _style() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.ubuntu().fontFamily,
    );
  }

  Widget _buttons({
    Color colors = const Color.fromRGBO(55, 59, 94, 1),
    required Widget widget,
  }) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 40,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: widget,
    );
  }
}
