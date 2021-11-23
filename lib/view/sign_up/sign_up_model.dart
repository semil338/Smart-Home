import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/services/database.dart';
import 'package:smart_home/widgets/show_alert_dialog.dart';
import 'package:smart_home/widgets/validations.dart';

class SignUpModel extends ChangeNotifier {
  SignUpModel({
    required this.auth,
    this.isLoading = false,
    this.hidePassword = true,
    this.boxValue = false,
    this.autoValidate = false,
  });
  final AuthBase auth;

  bool isLoading;
  bool? boxValue;
  bool hidePassword;
  bool _disposed = false;
  bool autoValidate;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ImageProvider img = const AssetImage("assets/images/bg-4.jpg");

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

  Icon showIcon() {
    if (hidePassword) {
      return const Icon(Icons.visibility);
    } else {
      return const Icon(Icons.visibility_off);
    }
  }

  void submit(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final auth = Provider.of<AuthBase>(context, listen: false);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      debugPrint("Success");
      updateWith(isLoading: true);

      try {
        await auth
            .createAccountWithEmailAndPassword(
                emailController.text, passController.text)
            .then((value) {
          final database = Provider.of<Database>(context, listen: false);
          database.addPersonalData(
            uId: value!.uid,
            name: nameController.text,
            email: emailController.text,
          );
        });

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context,
            title: "Sign Up",
            content: getMessageFromErrorCode(e.code),
            defaultActionText: "OK");
        updateWith(isLoading: false);
      }
    } else {
      updateWith(autoValidate: true);
    }
  }

  void goBack(BuildContext context) {
    formKey.currentState!.reset();
    emailController.clear();
    passController.clear();
    nameController.clear();
    nameFocusNode.unfocus();
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    updateWith(autoValidate: false);

    Navigator.pop(context);
  }

  void emailEditingComplete(BuildContext context) {
    FocusScope.of(context).requestFocus(passwordFocusNode);
  }

  void updateWith({
    bool? isLoading,
    bool? hidePassword,
    bool? boxValue,
    bool? autoValidate,
  }) {
    this.isLoading = isLoading ?? this.isLoading;
    this.hidePassword = hidePassword ?? this.hidePassword;
    this.boxValue = boxValue ?? this.boxValue;
    this.autoValidate = autoValidate ?? this.autoValidate;
    notifyListeners();
  }
}
