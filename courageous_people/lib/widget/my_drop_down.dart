import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MyDropDown extends HookWidget{
  final void Function(String) onSelect;
  List<String>? contents;
  List<String>? widgetContents;
  String title;
  double? width;

  MyDropDown({
    required this.title,
    required this.onSelect,
    this.contents,
    this.widgetContents,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final titleNotifier = useState<String?>(title);

    final _contents = contents ?? widgetContents;

    if(_contents == null) return Container();

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(8),
        width: width,
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
                itemCount: _contents.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    onSelect(_contents[index]);
                    Navigator.pop(context, _contents[index]);
                  },
                  child: contents != null
                      ? _contentItem(_contents[index])
                      : _widgetContentItem(_contents[index], 'assets/images/pukka.png'),
                ),
                separatorBuilder: (context, index) => Divider(thickness: 1),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _contentItem(String title) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        title,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _widgetContentItem(
      String title,
      String imageUri,
      ) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(imageUri, width: 80, height: 80),
          ),
        ],
      ),
    );
  }
}