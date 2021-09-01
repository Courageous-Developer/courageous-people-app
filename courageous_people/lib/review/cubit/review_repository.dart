import 'package:courageous_people/mock_data.dart';

import '../../model/review_data.dart';
import '../../classes.dart';


class ReviewRepository {
  Future<List<Review>> getReviews(int storeId) async {
    await Future.delayed(Duration(seconds: 1));
    final result = ReviewMockData.reviewJson;
    List<Review> reviewList = [];

    for(Json review in result) {
      // todo: imageurl, tags 추후 처리
      if(review['store_id'] == storeId) reviewList.add(Review(
          review['store_id'],  review['user_id'],  4.5,
          review['comment'], review['createAt'], null, null));
    }

    return reviewList;
  }
}