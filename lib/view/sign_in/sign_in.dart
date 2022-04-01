import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/view/sign_in/forget_password.dart';
import 'package:smart_home/view/sign_in/sign_in_model.dart';
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Consumer<SignInModel>(
  //       builder: (context, model, _) => SingleChildScrollView(
  //           child: ConstrainedBox(
  //         constraints:
  //             BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
  //         child: Stack(
  //           children: [
  //             Container(
  //               height: double.infinity,
  //               width: double.infinity,
  //               decoration: const BoxDecoration(
  //                   image: DecorationImage(
  //                 // filterQuality: FilterQuality.high,
  //                 image: NetworkImage(
  //                     "https://images.unsplash.com/photo-1523755231516-e43fd2e8dca5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80"),
  //                 fit: BoxFit.cover,
  //               )),
  //             ),
  //             Container(
  //               width: 350,
  //               height: 200,
  //               decoration: BoxDecoration(image: DecorationImage(image: bgimg)),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(top: 130),
  //               child: Opacity(
  //                   opacity: model.isLoading ? 0.4 : 1,
  //                   child: AbsorbPointer(
  //                       absorbing: model.isLoading,
  //                       child: SafeArea(
  //                         // padding: const EdgeInsets.all(25.0),
  //                         child: Container(
  //                           padding: const EdgeInsets.all(25),
  //                           decoration: BoxDecoration(
  //                               color: Colors.white.withOpacity(0.8),
  //                               borderRadius: const BorderRadius.only(
  //                                   topLeft: Radius.circular(60),
  //                                   topRight: Radius.circular(60))),
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             crossAxisAlignment: CrossAxisAlignment.stretch,
  //                             children: [
  //                               _buildForm(context, model),
  //                               _buildButtons(context, model),
  //                             ],
  //                           ),
  //                         ),
  //                       ))),
  //             ),
  //             showLoading(model),
  //           ],
  //         ),
  //       )),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Consumer<SignInModel>(
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

  Widget bodyContent(SignInModel model, BuildContext context) {
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

  Widget formContainer(BuildContext context, SignInModel model) {
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

  Widget _buildForm(BuildContext context, SignInModel model) {
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
              showText("Login"),
            ],
          ),
          const SizedBox(height: 30),
          buildEmailField(model, "Enter your Email"),
          const SizedBox(height: 20),
          buildPasswordField(model, context, "Enter your Password"),
          const SizedBox(height: 10),
          _buildCheckBox(model, context),
          const SizedBox(height: 30),
          buildButton(model, context, "Login"),
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
}
