 import 'package:flutter/material.dart';
import '../model/tag_data.dart';

class TagWidget extends StatelessWidget {
  final TagData tag;
  final List<MaterialColor> colors = [Colors.red, Colors.blue, Colors.amber, Colors.pink,
    Colors.green, Colors.purple, Colors.teal, Colors.brown];

  final FontWeight? fontWeight;

  TagWidget({
    Key? key,
    required this.tag,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: colors[tag.colorIndex].shade300,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 10),
          Text(
            tag.content,
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
