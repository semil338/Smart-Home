import 'package:flutter/material.dart';

Future<dynamic> showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String defaultActionText,
  String? cancelActionText,
}) {
  return showDialog(
    barrierDismissible: cancelActionText != null ? false : true,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if (cancelActionText != null)
          TextButton(
            // style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all(
            //         const Color.fromRGBO(55, 59, 94, 1))),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelActionText,
              style: const TextStyle(color: Color.fromRGBO(55, 59, 94, 1)),
            ),
          ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(55, 59, 94, 1))),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            defaultActionText,
            style: const TextStyle(color: Colors.white),
          ),
        )
      ],
    ),
  );
}
