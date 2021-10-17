import 'package:courageous_people/model/review_data.dart';
import 'package:courageous_people/model/tag_data.dart';
import 'package:courageous_people/widget/tag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// todo: 색 반전

class ReviewTile extends HookWidget {
  final ReviewData review;

  ReviewTile({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                review.imageUri.length == 0
                    ? SizedBox(height: 0)
                    : _imageSection(),
                _commentSection(),
                review.tags.length == 0
                    ? SizedBox(height: 0)
                    : _tagSection(),
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
        padding: EdgeInsets.only(left: 10, right: 25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              review.userNickname,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Text(
              review.createAt.split('T')[0],
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );

  Widget _imageSection() => Image.network(review.imageUri[0]);

  Widget _commentSection() =>
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Text(review.comment),
      );

  Widget _tagSection() =>
      Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: review.tags.map(
                (tag) => TagWidget(tag: tag),
          ).toList(),
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
            tag: TagData('500-1000 (ml)', 2),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}