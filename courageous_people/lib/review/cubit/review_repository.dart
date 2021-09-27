import 'package:http/http.dart' as http;

import '../../model/review_data.dart';
import '../../common/classes.dart';
import '../../common/constants.dart';
import '../../utils/interpreters.dart';


class ReviewRepository {
  Future<List<Review>> getReviews(int storeId) async {
    final http.Response response = await http.get(
      Uri.parse('$NON_AUTH_SERVER_URL/review/$storeId'),
      headers: {
        "Accept": "application/json",
      },
    );

    // todo: imageurl 추후 처리

    return reviewInterpret(response.body);
  }
}