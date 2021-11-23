import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/view/sign_up/sign_up.dart';
import 'package:smart_home/view/sign_up/sign_up_model.dart';
import 'package:smart_home/widgets/widgets.dart';

class SignInModel extends ChangeNotifier {
  SignInModel({
    required this.auth,
    this.isLoading = false,
    this.hidePassword = true,
    this.boxValue = false,
    this.autoValidate = false,
  });

  final AuthBase auth;
  bool isLoading;
  bool autoValidate;
  bool? boxValue;
  bool hidePassword;
  bool _disposed = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ImageProvider img = const AssetImage("assets/images/bg-1.jpg");
  String img1 =
      "https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1374&q=80";

  @override
  void dispose() {
    _disposed = true;
    emailController.dispose();
    passController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void handleRememberMe(bool? value) {
    boxValue = value;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value!);
        prefs.setString('email', emailController.text);
        prefs.setString('password', passController.text);
      },
    );
    updateWith(boxValue: value);
  }

  void goToSignUp(BuildContext context) {
    formKey.currentState!.reset();
    emailController.clear();
    passController.clear();
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();

    updateWith(autoValidate: false);

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<SignUpModel>(
              create: (context) => SignUpModel(auth: auth),
              child: const SignUpPage()),
          fullscreenDialog: true),
    );
  }

  Icon showIcon() {
    if (hidePassword) {
      return const Icon(Icons.visibility);
    } else {
      return const Icon(Icons.visibility_off);
    }
  }

  void loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String? _email = _prefs.getString("email") ?? "";
      String? _password = _prefs.getString("password") ?? "";
      bool? _rememberMe = _prefs.getBool("remember_me") ?? false;

      if (_rememberMe) {
        updateWith(
            boxValue: true, emailController: _email, passController: _password);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void submit(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      debugPrint("Success");
      updateWith(isLoading: true);

      try {
        await auth.signInWithEmailAndPassword(
            emailController.text, passController.text);
        // Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context,
            title: "Sign in",
            content: getMessageFromErrorCode(e.code),
            defaultActionText: "OK");
        updateWith(isLoading: false);
      }
    } else {
      updateWith(autoValidate: true);
    }
  }

  void updateWith({
    String? emailController,
    String? passController,
    bool? isLoading,
    bool? isRegister,
    bool? hidePassword,
    bool? boxValue,
    bool? autoValidate,
  }) {
    this.isLoading = isLoading ?? this.isLoading;
    this.hidePassword = hidePassword ?? this.hidePassword;
    this.boxValue = boxValue ?? this.boxValue;
    this.autoValidate = autoValidate ?? this.autoValidate;
    this.emailController.text = emailController ?? this.emailController.text;
    this.passController.text = passController ?? this.passController.text;
    notifyListeners();
  }

  void emailEditingComplete(BuildContext context) {
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }
}
