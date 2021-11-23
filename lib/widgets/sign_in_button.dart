import 'package:flutter/material.dart';

class SocialSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String assetName;
  final Color color;
  final double height;
  const SocialSignInButton({
    Key? key,
    required this.onPressed,
    required this.assetName,
    required this.color,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
        ),
        onPressed: onPressed,
        child: Image.asset(
          assetName,
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double height;
  final String text;
  final Color color;
  final Color textColor;
  final double fontSize;

  const SignInButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height = 50,
    required this.color,
    this.textColor = Colors.white,
    this.fontSize = 1.1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textScaleFactor: fontSize,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
