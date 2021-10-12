import 'package:courageous_people/utils/http_client.dart';
import 'package:http/http.dart' as http;

import '../../model/review_data.dart';
import '../../common/classes.dart';
import '../../common/constants.dart';
import '../../utils/interpreters.dart';

class ReviewRepository {
  Future<List<Review>> getReviews(int storeId) async {
    final http.Response response = await httpRequestWithoutToken(
      requestType: 'GET',
      path: '/board/review/$storeId',
    );

    return reviewInterpret(response.body);
  }

  Future<int> addReview({
    required int storeId,
    required int userId,
    required String comment,
    String? imageUrl,
  }) async {
    final response = await httpRequestWithToken(
      requestType: 'POST',
      path: '/board/review',
      body: {
        'user': userId,
        'store': storeId,
        'content': comment,
        'review_img': imageUrl ?? '',
      }
    );

    print(response.statusCode);
    print(response.body);

    return response.statusCode;
  }
}