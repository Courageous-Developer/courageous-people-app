import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MyDropDown extends HookWidget{
  String title;
  final List<String> contents;
  double? width;
  TextEditingController? controller;

  MyDropDown({
    required this.title,
    required this.contents,
    this.width,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final titleNotifier = useState<String?>(title);

    return GestureDetector(
      child: Container(
        width: 150,
        height: 40,
        // padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Text(
          titleNotifier.value ?? title,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 0.5,
            color: Colors.grey.shade700,
          ),
        ),
      ),
      onTap: () async {
        titleNotifier.value = await showDialog(
          context: context,
          builder: (context) => Padding(
            padding: EdgeInsets.all(40),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 0,
                  color: Colors.black,
                ),
              ),
              child: ListView.separated(
                itemCount: contents.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Navigator.pop(context, contents[index]),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      contents[index],
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => Divider(thickness: 1),
              ),
            ),
          ),
        );
      },
    );
  }
}