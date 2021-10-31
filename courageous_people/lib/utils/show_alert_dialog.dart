import 'package:flutter/material.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  required String title,
  void Function()? onPressed,
}) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: onPressed ?? () => Navigator.pop(context),
          child: Text('확인'),
        ),
      ],
    ),
  );
}