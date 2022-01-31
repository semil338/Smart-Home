import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/view/sign_up/sign_up_model.dart';
import 'package:smart_home/widgets/widgets.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Consumer<SignUpModel>(
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
                        ),
                      ),
                    ),
                  ),
                ),
                showLoading(model),
              ],
            ),
          ),
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
          showText("Sign up"),
          const SizedBox(height: 30),
          _buildNameField(model),
          const SizedBox(height: 20),
          buildEmailField(model, "Email"),
          const SizedBox(height: 20),
          buildPasswordField(model, context, "Password"),
          const SizedBox(height: 30),
          buildButton(model, context, "Sign up"),
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
