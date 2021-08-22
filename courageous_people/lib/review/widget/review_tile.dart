import 'package:courageous_people/my_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewTile extends StatelessWidget {
  final String id;
  final double grade; // 별점
  final String comment;

  Image? image;
  List<String>? tags;

  ReviewTile(this.id, this.grade, this.comment, {
    Key? key,
    this.image,
    this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey,
        child: Column(
          children: [
            Container(
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
                            id,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          MyRatingBar(4.5),

                        ],
                      ),
                    ),
                    Container(
                      child: Text(
                        '${DateTime.now().toString().split(' ')[0]}',
                        style: TextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(
                'assets/images/pukka.png',
              width: MediaQuery.of(context).size.width,
            )
          ],
        ),
      ),
    );
  }
}
