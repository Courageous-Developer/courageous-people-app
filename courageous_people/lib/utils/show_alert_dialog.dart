import 'package:courageous_people/common/constants.dart';
import 'package:flutter/material.dart';

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  void Function()? onSubmit,
  void Function()? onCancel,
}) async {
  return await showDialog(
    context: context,
    builder: (context) => _MyAlertDialog(
      title: title,
      onSubmit: onSubmit,
      onCancel: onCancel,
    ),
  );
}

class _MyAlertDialog extends StatelessWidget {
  _MyAlertDialog({
    Key? key,
    required this.title,
    this.onSubmit,
    this.onCancel,
  }) : super(key: key);

  final String title;
  void Function()? onSubmit;
  void Function()? onCancel;

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
            Container(
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Row(
                children: [
                  _submitButton(
                    borderRadius: onCancel == null
                        ? null
                    : BorderRadius.only(bottomLeft: Radius.circular(5)),
                    onSubmit: onSubmit ?? () => Navigator.pop(context, true),
                  ),
                  if(onCancel != null)
                    _cancelButton(onCancel: onCancel!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton({
    required void Function() onSubmit,
    required BorderRadius? borderRadius,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onSubmit,
        child: Container(
          decoration: BoxDecoration(
            color: THEME_COLOR,
            borderRadius: borderRadius ?? BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
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
    );
  }

  Widget _cancelButton({required void Function() onCancel}) {
    return Expanded(
      child: GestureDetector(
        onTap: onCancel,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade500,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              '취소',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}