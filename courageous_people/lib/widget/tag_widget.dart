import 'dart:math';

import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final String content;
  final Color? backgroundColor;
  final FontWeight? fontWeight;

  const TagWidget({
    Key? key,
    required this.content,
    this.backgroundColor,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MaterialColor> colors = [Colors.red, Colors.blue, Colors.amber, Colors.pink,
      Colors.green, Colors.grey, Colors.purple, Colors.teal, Colors.brown];

    final index = Random().nextInt(colors.length);

    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: backgroundColor ?? colors[index].shade300,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: fontWeight,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
