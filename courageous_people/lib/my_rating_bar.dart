import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

class MyRatingBar extends StatelessWidget {
  final double rating;

  const MyRatingBar(this.rating, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemSize: 16,
      itemCount: 5,
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.yellow,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}
