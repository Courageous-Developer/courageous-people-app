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

    // todo: imageurl 추후 처리

    return reviewInterpret(response.body);
  }
}