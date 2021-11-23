import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/widgets/widgets.dart';

// ignore: must_be_immutable
class OutlineBorderTextFormField extends StatefulWidget {
  FocusNode myFocusNode;
  TextEditingController tempTextEditingController;
  String labelText;
  TextInputType keyboardType;
  bool autofocus = false;
  TextInputAction textInputAction;
  List<TextInputFormatter> inputFormatters;
  Function validation;
  bool checkOfErrorOnFocusChange = false;
  //If true validation is checked when ever focus is changed

  @override
  State<StatefulWidget> createState() {
    return _OutlineBorderTextFormField();
  }

  OutlineBorderTextFormField(
      {Key? key,
      required this.labelText,
      required this.autofocus,
      required this.tempTextEditingController,
      required this.myFocusNode,
      required this.inputFormatters,
      required this.keyboardType,
      required this.textInputAction,
      required this.validation,
      required this.checkOfErrorOnFocusChange})
      : super(key: key);
}

class _OutlineBorderTextFormField extends State<OutlineBorderTextFormField> {
  bool isError = false;
  String errorString = "";

  getLabelTextStyle(color) {
    return TextStyle(fontSize: 12.0, color: color);
  } //label text style

  getTextFieldStyle() {
    return const TextStyle(
      fontSize: 12.0,
      color: Colors.black,
    );
  } //textField style

  getErrorTextFieldStyle() {
    return const TextStyle(
      fontSize: 10.0,
      color: Colors.red,
    );
  } // Error text style

  getBorderColor(isfocus) {
    return isfocus ? Colors.deepPurple : Colors.black54;
  } //Border colors according to focus

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 15.0, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FocusScope(
            child: Focus(
              onFocusChange: (focus) {
                //Called when ever focus changes
                debugPrint("focus: $focus");
                setState(() {
                  getBorderColor(focus);
                  if (widget.checkOfErrorOnFocusChange &&
                      widget
                          .validation(widget.tempTextEditingController.text)
                          .toString()
                          .isNotEmpty) {
                    isError = true;
                    errorString = widget
                        .validation(widget.tempTextEditingController.text);
                  } else {
                    isError = false;
                    errorString = widget
                        .validation(widget.tempTextEditingController.text);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                    border: Border.all(
                      width: 1,
                      style: BorderStyle.solid,
                      color: isError
                          ? Colors.red
                          : getBorderColor(widget.myFocusNode.hasFocus),
                    )),
                child: TextFormField(
                  focusNode: widget.myFocusNode,
                  controller: widget.tempTextEditingController,
                  style: getTextFieldStyle(),
                  autofocus: widget.autofocus,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  inputFormatters: widget.inputFormatters,
                  validator: (string) {
                    if (widget
                        .validation(widget.tempTextEditingController.text)
                        .toString()
                        .isNotEmpty) {
                      setState(() {
                        isError = true;
                        errorString = widget
                            .validation(widget.tempTextEditingController.text);
                      });
                      return "";
                    } else {
                      setState(() {
                        isError = false;
                        errorString = widget
                            .validation(widget.tempTextEditingController.text);
                      });
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    labelStyle: isError
                        ? getLabelTextStyle(Colors.red)
                        : getLabelTextStyle(Colors.deepPurple),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                    fillColor: Colors.grey[200],
                    filled: true,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    border: InputBorder.none,
                    errorStyle: const TextStyle(height: 0),
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
              visible: isError ? true : false,
              child: Container(
                  padding: const EdgeInsets.only(left: 15.0, top: 2.0),
                  child: Text(
                    errorString,
                    style: getErrorTextFieldStyle(),
                  ))),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode myFocusNode = new FocusNode();
  TextEditingController tempTextEditingController = TextEditingController();

  FocusNode myFocusNode1 = new FocusNode();
  TextEditingController tempTextEditingController1 = TextEditingController();
  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  String getTempIFSCValidation(String text) {
    return text.length > 5 ? "* Please enter valid IFSC Code" : "";
  }

  String getTempAccountValidation(String text) {
    return text.length > 8 ? "* Please enter valid Account Number" : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AppBar"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            OutlineBorderTextFormField(
              labelText: "Account Number*",
              myFocusNode: myFocusNode,
              tempTextEditingController: tempTextEditingController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              autofocus: false,
              checkOfErrorOnFocusChange: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(18),
                WhitelistingTextInputFormatter.digitsOnly
              ],
              validation: (textToValidate) {
                return getTempAccountValidation(textToValidate);
              },
            ),
            OutlineBorderTextFormField(
              labelText: "Re- Enter Account Number*",
              myFocusNode: myFocusNode1,
              tempTextEditingController: tempTextEditingController1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              autofocus: false,
              checkOfErrorOnFocusChange: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(18),
                WhitelistingTextInputFormatter.digitsOnly
              ],
              validation: (textToValidate) {
                print("Value Validated");
                return getTempIFSCValidation(textToValidate);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: validateAndSave, //call the validation method
        tooltip: 'Validate',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

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
