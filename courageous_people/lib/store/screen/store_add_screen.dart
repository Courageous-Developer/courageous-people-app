import 'package:flutter/material.dart';
import '../../widget/transparent_app_bar.dart';

class StoreAddScreen extends StatelessWidget {
  const StoreAddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(
        title: '가게 추가하기',
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          TextField(),
          TextField(),
          TextField(),
        ],
      ),
    );
  }
}
