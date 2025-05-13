import 'package:flutter/material.dart';

Future<void> buildAlertDiagram({
  required BuildContext context,
  required Future<void> Function() onConfirmDelete,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Confirm deletion"),
      content: Text("Are you sure you want to delete this record? This action is irreversible."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            await onConfirmDelete();
            Navigator.pop(context); 
          },
          child: Text("Remove"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    ),
  );
}
void showErrorMessage(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 4),
      content: Text(
        content,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      
    ),
  );
}
void showSuccessMessage(BuildContext context, String content){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 4),
      content: Text(content,style: TextStyle(
       color: Colors.white,),
      ),
      backgroundColor: Colors.green
      )
      );
}

