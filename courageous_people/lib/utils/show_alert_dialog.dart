import 'package:courageous_people/common/constants.dart';
import 'package:flutter/material.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  required String title,
  void Function()? onPressed,
}) async {
  await showDialog(
    context: context,
    builder: (context) => _MyAlertDialog(
      title: title,
      onPressed: onPressed,
    ),
  );
}

class _MyAlertDialog extends StatelessWidget {
  _MyAlertDialog({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  final String title;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(50),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
      ),
      child: Container(
        height: 150,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GestureDetector(
              onTap: onPressed ?? () => Navigator.pop(context),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: THEME_COLOR,
                ),
                child: Center(
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}