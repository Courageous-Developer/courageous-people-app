import 'package:courageous_people/model/review_data.dart';
import 'package:courageous_people/widget/tag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// todo: 색 반전

class ReviewTile extends HookWidget {
  late String userName;
  late String comment;
  late String createAt;
  late String? imageUri;
  late String? tags;

  ReviewTile({
    Key? key,
    required Review data,
  }) : super(key: key) {
    this.userName = 'ㅎㅎㅎ'; //todo: userId로 userName 받아오기
    this.comment = data.comment;
    this.createAt = data.createAt;
    this.imageUri = data.imageUri;
  }

  @override
  Widget build(BuildContext context) {
    final double SCREEN_WIDTH = MediaQuery
        .of(context)
        .size
        .width;
    final double SCREEN_HEIGHT = MediaQuery
        .of(context)
        .size
        .height;
    ValueNotifier<bool> isExpandedNotifier = useState<bool>(false);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey[200],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _userSection(),
                Container(
                  child: imageUri != null
                      ? _imageSection()
                      : null,
                ),
                _commentSection(),
                _tagSection(),
                _containerNotifierSection(
                  isExpanded: isExpandedNotifier.value,
                  expansionCallback: (index, isExpanded) {
                    isExpandedNotifier.value = !isExpanded;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userSection() =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              userName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Text(
              createAt,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );

  Widget _imageSection() => Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
  );

  Widget _commentSection() =>
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Text(comment),
      );

  Widget _tagSection() =>
      Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            TagWidget(content: '꿀맛'),
            TagWidget(content: '존맛')
          ],
        ),
      );

  Widget _containerNotifierSection({
    required bool isExpanded,
    required void Function(int, bool)? expansionCallback
  }) => ExpansionPanelList(
    expansionCallback: expansionCallback,
    elevation: 0,
    children: [
      ExpansionPanel(
        isExpanded: isExpanded,
        backgroundColor: Colors.grey[300],
        canTapOnHeader: true,
        headerBuilder: (context, isExpanded) =>
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text(
                '용기 정보',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        body: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border(top: BorderSide(width: 0.2)),
          ),
          child: TagWidget(
            content: '500-1000 (ml)',
            backgroundColor: Colors.grey.shade500,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}