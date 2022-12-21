import 'package:flutter/material.dart';

//Method For Alert Dialog Of Delete Books
showAlertDialog(
  BuildContext context,
  String bookTitle,
  VoidCallback onPressed,
) {
  //Button For Cancel Variable
  Widget buCancel = TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: _text("Cancel", Colors.red),
  );

  //Button For Delete Variable
  Widget buDelete = TextButton(
    onPressed: () {
      onPressed();
      Navigator.pop(context);
    },
    child: _text("Delete", Colors.black),
  );

  //Alert Dialog Coding
  var alertDialog = AlertDialog(
    title: _text("Are You Sure To Delete $bookTitle", Colors.black),
    actions: [buCancel, buDelete],
  );

  showDialog(
      context: context,
      builder: ((context) {
        return alertDialog;
      }));
}

//Method For Text View
Widget _text(String text, Color textColor) {
  return Text(text, style: TextStyle(fontSize: 17, color: textColor));
}
