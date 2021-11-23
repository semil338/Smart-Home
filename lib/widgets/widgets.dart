export 'borders.dart';
export 'show_alert_dialog.dart';
export 'validations.dart';
export 'sign_in_button.dart';
export 'constant.dart';

import 'package:flutter/material.dart';
import 'package:smart_home/widgets/borders.dart';
import 'package:smart_home/widgets/constant.dart';
import 'package:smart_home/widgets/sign_in_button.dart';
import 'package:smart_home/widgets/text_field.dart';
import 'package:smart_home/widgets/validations.dart';

Opacity showLoading(var model) {
  return Opacity(
    opacity: model.isLoading ? 1.0 : 0,
    child: const Center(
      child: CircularProgressIndicator(
        color: fontColor,
      ),
    ),
  );
}

Container showText(String text) {
  return Container(
    alignment: Alignment.topLeft,
    child: Text(
      text,
      textAlign: TextAlign.left,
      style: style(fontSize: 32, weight: FontWeight.bold),
    ),
  );
}

SignInButton buildButton(var model, BuildContext context, String text) {
  return SignInButton(
    text: text,
    onPressed: () => model.submit(context),
    color: fontColor,
    fontSize: 1.5,
  );
}

TextFormField buildPasswordField(
    var model, BuildContext context, String hintText) {
  return TextFormField(
    onEditingComplete: () => model.submit(context),
    focusNode: model.passwordFocusNode,
    controller: model.passController,
    validator: validatePassword,
    obscureText: model.hidePassword,
    decoration: InputDecoration(
      hintText: hintText,
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

CustomTextField buildEmailField(var model, String hintText) {
  return CustomTextField(
    editingComplete: () => model.emailEditingComplete,
    focusNode: model.emailFocusNode,
    controller: model.emailController,
    hintText: hintText,
  );
}
