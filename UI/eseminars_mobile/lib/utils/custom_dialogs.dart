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
  static void showInformationDialog(BuildContext context, String message, VoidCallback onOkPressed,) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.info,
    animType: AnimType.scale,
    title: 'Info',
    desc: message,
    btnOkOnPress: onOkPressed,
    btnCancelOnPress: () {
    },
    btnOkColor: Colors.green,
    btnCancelColor: Colors.red,
  ).show();
}
}
