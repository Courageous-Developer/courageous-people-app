import 'package:flutter/material.dart';

class MyInputForm extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? title;
  final Widget? additionalButton;
  final TextInputType? textInputType;
  final bool? obscureText;
  final String? errorText;
  final String? helperText;
  final bool enabled;
  final bool filled;
  final String? controllerText;
  final void Function(String)? onChanged;

  MyInputForm({
    Key? key,
    this.controller,
    this.title,
    this.additionalButton,
    this.textInputType,
    this.obscureText,
    this.errorText,
    this.helperText,
    this.onChanged,
    this.enabled = true,
    this.filled = false,
    this.controllerText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title ?? SizedBox(height: 0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 30,
                child: TextFormField(
                  enabled: enabled,
                  onChanged: onChanged,
                  obscureText: obscureText ?? false,
                  keyboardType: textInputType,
                  decoration: InputDecoration(
                    errorText: errorText,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: helperText == null ? Colors.black : Colors.green,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: helperText == null ? Colors.blue : Colors.green,
                        width: 2,
                      ),
                    ),
                    helperText: helperText,
                    helperStyle: TextStyle(color: Colors.green),
                    // filled: filled,
                    // fillColor: Colors.grey[300],
                    // contentPadding: EdgeInsets.symmetric(
                    //   vertical: 0,
                    //   horizontal: 15,
                    // ),
                    // border: OutlineInputBorder(
                    //   borderSide: BorderSide(
                    //     color: Colors.red,
                    //   ),
                    //   borderRadius: BorderRadius.all(Radius.circular(5)),
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.all(Radius.circular(5)),
                    //   borderSide: BorderSide(
                    //       color: Colors.black
                    //   ),
                    // ),
                  ),
                  controller: controller,
                ),
              ),
            ),
            SizedBox(width: additionalButton == null ? 0 : 8),
            additionalButton ?? SizedBox(width: 0),
          ],
        ),
      ],
    );
  }
}
