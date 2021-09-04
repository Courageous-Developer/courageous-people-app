import 'package:flutter/material.dart';

class StoreAddScreen extends StatelessWidget {
  final storeData;

  const StoreAddScreen(this.storeData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(storeData['title']),
        ),
      ),
    );
  }

  String _pureTitle(String title) {
    final first = title.split('<b>');
    if (first.length == 1) return first[0];

    final second = first[1].split('</b>');
    return '${first[0]}${second[0]}${second[1]}';
  }
}
