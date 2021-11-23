import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const enabledBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color.fromRGBO(55, 59, 94, 1)),
  borderRadius: BorderRadius.all(
    Radius.circular(25),
  ),
);
const focusBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color.fromRGBO(55, 59, 94, 1)),
  borderRadius: BorderRadius.all(
    Radius.circular(25),
  ),
);
const errorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red),
  borderRadius: BorderRadius.all(
    Radius.circular(25),
  ),
);

TextStyle style({
  Color color = const Color.fromRGBO(55, 59, 94, 1),
  FontWeight weight = FontWeight.normal,
  required double fontSize,
}) {
  return TextStyle(
    color: color,
    fontWeight: weight,
    fontFamily: GoogleFonts.roboto().fontFamily,
    fontSize: fontSize,
  );
}

Widget buildTextField({
  required void Function() editingComplete,
  required TextInputAction inputAction,
  required FocusNode focusNode,
  required TextEditingController controller,
  required String? Function(String?) validate,
  required TextInputType inputType,
  required String hintText,
  required IconData icon,
}) {
  return TextFormField(
    onEditingComplete: editingComplete,
    textInputAction: inputAction,
    focusNode: focusNode,
    controller: controller,
    validator: validate,
    keyboardType: inputType,
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(
        icon,
        color: const Color.fromRGBO(55, 59, 94, 1),
      ),
      enabledBorder: enabledBorder,
      focusedBorder: focusBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
    ),
  );
}
