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
    // if(controllerText != null)  controller.text = controllerText!;

    return Container(
      // height: 14.0,
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
                    enabled: enabled,
                    onChanged: onChanged,
                    obscureText: obscureText ?? false,
                    keyboardType: textInputType,
                    decoration: InputDecoration(
                      filled: filled,
                      fillColor: Colors.grey[300],
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
