import 'package:courageous_people/model/review_data.dart';
import 'package:courageous_people/my_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewTile extends StatelessWidget {
  late String userName;
  late double grade; // 별점
  late String comment;
  late String createAt;
  late String? imageUri;
  late String? tags;

  ReviewTile({
    Key? key,
    required Review data
  }): super(key: key) {
    this.userName = 'ㅎㅎㅎ';  //todo: userId로 userName 받아오기
    this.grade = data.grade;
    this.comment = data.comment;
    this.createAt = data.createAt;
     this.imageUri = data.imageUri;
     this.tags = data.tags;
  }

  @override
  Widget build(BuildContext context) {
    final double SCREEN_WIDTH = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            _userSection(),
            _commentSection(SCREEN_WIDTH),
            _tagSection()
          ],
        ),
      ),
    );
  }

  Widget _userSection() => Container(
    height: 60,
    child: Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/pukka.png'),
            ),
          ),
          Container(
            height: 60.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                MyRatingBar(grade),
              ],
            ),
          ),
          Container(
            child: Text(
              createAt,
              style: TextStyle(),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _commentSection(double imageWidth) => Container(
    child: Column(
      children: [
        if(imageUri != null) Image.asset(
          imageUri!,
          width: imageWidth,
        ),
        Text(comment),
      ],
    ),
  );

  Widget _tagSection() => Container();
}
