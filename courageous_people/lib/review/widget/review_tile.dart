import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/utils/show_alert_dialog.dart';
import 'package:flutter/material.dart';

import '../../model/review_data.dart';
import '../../widget/tag_widget.dart';

class ReviewTile extends StatelessWidget {
  final ReviewData review;

  final void Function() onCorrectionPressed;
  final void Function() onDeletionPressed;

  ReviewTile({
    Key? key,
    required this.review,
    required this.onCorrectionPressed,
    required this.onDeletionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(bottom: 45),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topSection(
            onCorrectionPressed: () async {
              await showAlertDialog(
                context: context,
                title: '수정하시겠습니까?',
                onSubmit: onCorrectionPressed,
                onCancel: () => Navigator.pop(context),
              );
            },
            onDeletionPressed: () async {
              await showAlertDialog(
                context: context,
                title: '삭제하시겠습니까?',
                onSubmit: () {
                  Navigator.pop(context);
                  onDeletionPressed();
                },
                onCancel: () => Navigator.pop(context),
              );
            },
          ),
          _imageSection(context),
          _commentSection(),
          _tagSection(),
        ],
      ),
    );
  }

  Widget _topSection({
    required void Function()? onCorrectionPressed,
    required void Function()? onDeletionPressed,
  }) {
    final userNickname = UserHive().userNickname ?? '';
    final isMyReview = review.userNickname == userNickname;

    print(UserHive().userNickname);
    print(UserHive().userEmail);
    print(UserHive().userId);
    print(UserHive().userManagerFlag);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _userSection(),
          if(isMyReview)
          _correctionButtonSection(
            onCorrectionPressed: onCorrectionPressed,
            onDeletionPressed: onDeletionPressed,
          ),
      ],
    );
  }

  Widget _userSection() => Container(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/user.png'),
          backgroundColor: Colors.transparent,
          radius: 18,
        ),
        SizedBox(width: 9),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.userNickname,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              // todo: 날짜 수정
              review.createAt.split('T')[0],
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _correctionButtonSection({
    required void Function()? onCorrectionPressed,
    required void Function()? onDeletionPressed,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: onCorrectionPressed,
          child: Text(
            '수정',
            style: TextStyle(fontSize: 13, color: Colors.blue),
          ),
        ),
        TextButton(
          onPressed: onDeletionPressed,
          child: Text(
            '삭제',
            style: TextStyle(fontSize: 13, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _imageSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: review.imageUri.length > 0 ? 15 : 0),
      alignment: Alignment.topLeft,
      child: review.imageUri.length > 0
          ?
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(review.imageUri[0]),
      )
          : SizedBox(height: 0),
    );
  }

  Widget _commentSection() => Container(
    padding: EdgeInsets.only(top: 18.5),
    alignment: Alignment.centerLeft,
    child: Text(review.comment),
  );

  Widget _tagSection() => Container(
    padding: EdgeInsets.only(top: 25),
    alignment: Alignment.centerLeft,
    child: review.tags.length > 0
        ?
    Row(
      mainAxisSize: MainAxisSize.min,
      children: review.tags.map(
            (tag) => TagWidget(tag: tag),
      ).toList(),
    )
        : SizedBox(height: 0),
  );
}