import 'package:flutter/material.dart';

class MyInputForm extends StatelessWidget {
  final TextEditingController controller;
  final Widget? title;
  final Widget? additionalButton;
  final TextInputType? textInputType;
  final bool? obscureText;
  final String? errorText;
  final String? helperText;
  final void Function(String)? onChanged;

  MyInputForm({
    Key? key,
    required this.controller,
    this.title,
    this.additionalButton,
    this.textInputType,
    this.obscureText,
    this.errorText,
    this.helperText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title ?? SizedBox(height: 0),
          SizedBox(height: 5),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: onChanged,
                    obscureText: obscureText ?? false,
                    keyboardType: textInputType,
                    decoration: InputDecoration(
                      errorText: errorText,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 15,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                            color: Colors.black
                        ),
                      ),
                      helperText: helperText,
                    ),
                    controller: controller,
                  ),
                ),
                SizedBox(width: additionalButton == null ? 0 : 8),
                additionalButton ?? SizedBox(width: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
