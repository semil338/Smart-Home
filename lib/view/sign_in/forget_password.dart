import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/services/auth.dart';
import 'package:smart_home/widgets/text_field.dart';
import 'package:smart_home/widgets/widgets.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool _autoValidate = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  ImageProvider img = const AssetImage("assets/images/forget_pass.jpg");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: fontColor),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Stack(
            children: [
              Opacity(
                opacity: _isLoading ? 0.4 : 1,
                child: AbsorbPointer(
                  absorbing: _isLoading,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: _buildForm(context),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: _isLoading ? 1.0 : 0,
                child: const Center(
                    child: CircularProgressIndicator(
                  color: fontColor,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode:
          _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _showText(),
          _showImage(),
          _buildEmailTextField(),
          const SizedBox(height: 30),
          _showButton(context),
        ],
      ),
    );
  }

  SignInButton _showButton(BuildContext context) {
    return SignInButton(
      text: "Send Link",
      onPressed: () => submit(context),
      color: fontColor,
      fontSize: 1.5,
    );
  }

  SizedBox _showImage() {
    return SizedBox(
      height: 250,
      width: 250,
      child: FittedBox(
        child: Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
            image: DecorationImage(image: img, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Container _showText() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "Forget password?",
        textAlign: TextAlign.left,
        style: style(fontSize: 27, weight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return CustomTextField(
      editingComplete: _emailEditingComplete,
      focusNode: _emailFocusNode,
      controller: _emailController,
      hintText: "Enter your Email",
    );
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  submit(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final auth = Provider.of<AuthBase>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await auth.forgetPassword(_emailController.text);
        Navigator.of(context).pop();
        showAlertDialog(context,
            title: "Attention",
            content: "Password Reset Email has been sent !",
            defaultActionText: "OK");
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context,
            title: "Error",
            content: getMessageFromErrorCode(e.code),
            defaultActionText: "OK");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
