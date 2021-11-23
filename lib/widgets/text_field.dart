import 'package:flutter/material.dart';
import 'package:smart_home/widgets/widgets.dart';

class CustomTextField extends StatelessWidget {
  final void Function()? editingComplete;
  final FocusNode focusNode;
  final TextEditingController controller;

  final String hintText;

  const CustomTextField({
    Key? key,
    required this.editingComplete,
    required this.focusNode,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: editingComplete,
      textInputAction: TextInputAction.next,
      focusNode: focusNode,
      controller: controller,
      validator: validateEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(
          Icons.email,
          color: fontColor,
        ),
        enabledBorder: enabledBorder,
        focusedBorder: focusBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );
  }
}
