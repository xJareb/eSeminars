import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MyDialogs {
  static void showSuccessDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Success',
      desc: message,
      btnOkOnPress: () {
        Navigator.pop(context,true);
      },
      btnOkColor: Colors.green,
    ).show();
  }

  static void showErrorDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'Error',
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
    ).show();
  }
}
