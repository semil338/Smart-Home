import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:smart_home/view/sign_up/sign_up_model.dart';
import 'package:smart_home/widgets/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  ImageProvider logo = const AssetImage("assets/images/icon.png");
  ImageProvider bgimg = const AssetImage("assets/images/bg-7.jpg");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Consumer<SignUpModel>(
        builder: (context, model, _) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Stack(
                children: [
                  bodyImage(context),
                  bodyContent(model, context),
                  showLoading(model),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bodyImage(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg-1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget bodyContent(SignUpModel model, BuildContext context) {
    return Opacity(
      opacity: model.isLoading ? 0.4 : 1,
      child: AbsorbPointer(
        absorbing: model.isLoading,
        child: Column(
          children: [
            headerBox(context),
            formContainer(context, model),
          ],
        ),
      ),
    );
  }

  Widget formContainer(BuildContext context, SignUpModel model) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(60),
          )),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildForm(context, model),
            _buildButtons(context, model),
          ],
        ),
      ),
    );
  }

  Widget headerBox(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.6,
            child: bodyImage2(context),
          ),
        ],
      ),
    );
  }

  Widget bodyImage2(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/icon.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, SignUpModel model) {
    return Form(
      key: model.formKey,
      autovalidateMode: model.autoValidate
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 19),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showText("Sign up"),
            ],
          ),
          const SizedBox(height: 30),
          _buildNameField(model),
          const SizedBox(height: 20),
          buildEmailField(model, "Email"),
          const SizedBox(height: 20),
          buildPasswordField(model, context, "Password"),
          const SizedBox(height: 20),
          buildButton(model, context, "Sign up"),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, SignUpModel model) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Already have an account ?",
              style: style(fontSize: 16),
            ),
            TextButton(
              onPressed: () => model.goBack(context),
              child: Text(
                "Sign in",
                style: style(fontSize: 16, color: Colors.red),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  TextFormField _buildNameField(SignUpModel model) {
    return TextFormField(
      controller: model.nameController,
      focusNode: model.nameFocusNode,
      validator: validateName,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.person,
          color: Color.fromRGBO(55, 59, 94, 1),
        ),
        hintText: "Full Name",
        enabledBorder: enabledBorder,
        focusedBorder: focusBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );
  }
}
