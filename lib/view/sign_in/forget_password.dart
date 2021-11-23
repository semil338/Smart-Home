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
  bool isLoading = false;
  bool emailSent = false;
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
                opacity: isLoading ? 0.4 : 1,
                child: AbsorbPointer(
                  absorbing: isLoading,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: _buildForm(context),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: isLoading ? 1.0 : 0,
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
      // ignore: deprecated_member_use
      autovalidate: _autoValidate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // const SizedBox(height: 10),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "Forget password?",
              textAlign: TextAlign.left,
              style: style(fontSize: 27, weight: FontWeight.bold),
            ),
          ),
          // const SizedBox(height: 30),
          SizedBox(
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
          ),
          // const SizedBox(height: 30),

          _buildEmailTextField(),
          const SizedBox(height: 30),
          SignInButton(
            text: "Send Link",
            onPressed: () => submit(context),
            color: fontColor,
            fontSize: 1.5,
          ),
        ],
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
        isLoading = true;
      });
      try {
        await auth.forgetPassword(_emailController.text);
        Navigator.of(context).pop();
        showAlertDialog(context,
            title: "Attention",
            content: "Password Reset Email has been sent !",
            defaultActionText: "OK");
        setState(() {
          emailSent = true;
        });
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context,
            title: "Error",
            content: e.message.toString(),
            defaultActionText: "OK");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
