import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/view/sign_in/forget_password.dart';
import 'package:smart_home/view/sign_in/sign_in_model.dart';
import 'package:smart_home/widgets/text_field.dart';
import 'package:smart_home/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  void initState() {
    final model = Provider.of<SignInModel>(context, listen: false);
    model.loadUserEmailPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Consumer<SignInModel>(
        builder: (context, model, _) => SingleChildScrollView(
            child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Stack(
            children: [
              Opacity(
                  opacity: model.isLoading ? 0.4 : 1,
                  child: AbsorbPointer(
                      absorbing: model.isLoading,
                      child: SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildForm(context, model),
                                _buildButtons(context, model),
                              ],
                            )),
                      ))),
              showLoading(model),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildForm(BuildContext context, SignInModel model) {
    return Form(
      key: model.formKey,
      // ignore: deprecated_member_use
      autovalidate: model.autoValidate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 19),
          showText("Log In"),
          const SizedBox(height: 30),
          buildEmailField(model),
          const SizedBox(height: 20),
          buildPasswordField(model, context),
          const SizedBox(height: 10),
          _buildCheckBox(model, context),
          const SizedBox(height: 30),
          buildButton(model, context, "Log in"),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, SignInModel model) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Don't have an account ?",
              style: style(fontSize: 16),
            ),
            TextButton(
              onPressed: () => model.goToSignUp(context),
              child: Text(
                "Sign up",
                style: style(fontSize: 16, color: Colors.red),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  SignInButton _buildButton(SignInModel model, BuildContext context) {
    return SignInButton(
      text: "Log in",
      onPressed: () => model.submit(context),
      color: fontColor,
      fontSize: 1.5,
    );
  }

  Row _buildCheckBox(SignInModel model, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all(fontColor),
              value: model.boxValue,
              onChanged: (value) => model.handleRememberMe(value),
            ),
            Text(
              "Remember me",
              style: style(fontSize: 15),
            ),
          ],
        ),
        TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const ForgetPassword(),
          )),
          child: Text(
            "Forget password?",
            style: style(fontSize: 15, color: Colors.red),
          ),
        ),
      ],
    );
  }

  Container _buildText() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "Log In",
        textAlign: TextAlign.left,
        style: style(fontSize: 32, weight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmailTextField(SignInModel model) {
    return CustomTextField(
      editingComplete: () => model.emailEditingComplete(context),
      focusNode: model.emailFocusNode,
      controller: model.emailController,
      hintText: "Enter your Email",
    );
  }

  Widget _buildPasswordTextField(SignInModel model) {
    return TextFormField(
      onEditingComplete: () => model.submit(context),
      focusNode: model.passwordFocusNode,
      controller: model.passController,
      validator: validatePassword,
      obscureText: model.hidePassword,
      decoration: InputDecoration(
        hintText: "Enter your Password",
        suffixIcon: IconButton(
          icon: model.showIcon(),
          onPressed: () => model.updateWith(hidePassword: !model.hidePassword),
          color: fontColor,
        ),
        prefixIcon: const Icon(
          Icons.lock,
          color: fontColor,
        ),
        enabledBorder: enabledBorder,
        focusedBorder: focusBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );
  }

  Opacity _showLoading(SignInModel model) {
    return Opacity(
      opacity: model.isLoading ? 1.0 : 0,
      child: const Center(
          child: CircularProgressIndicator(
        color: fontColor,
      )),
    );
  }
}
