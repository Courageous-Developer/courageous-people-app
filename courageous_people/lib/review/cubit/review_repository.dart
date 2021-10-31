import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../model/review_data.dart';
import '../../common/classes.dart';
import '../../common/constants.dart';
import '../../utils/interpreters.dart';

class ReviewRepository {
  Future<List<ReviewData>> getReviews(int storeId) async {
    final http.Response response = await httpRequestWithoutToken(
      requestType: 'GET',
      path: '/board/review/$storeId',
    );

    return toReviewList(response.body);
  }

  Future<int> addReview({
    required int storeId,
    required int userId,
    required String comment,
    Uint8List? pictureToByte,
  }) async {
    final addingReviewResponse = await httpRequestWithToken(
      requestType: 'POST',
      path: '/board/review',
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${TokenService().accessToken!}",
      },
      body: {
        'user': userId,
        'store': storeId,
        'content': comment,
      },
    );

    print('status: ${addingReviewResponse.statusCode}');

    if(pictureToByte == null || addingReviewResponse.statusCode != 201) {
      return addingReviewResponse.statusCode;
    }

    final reviewId = jsonDecode(addingReviewResponse.body)['id'];

    final multiPartData = MultipartFile.fromBytes(
      pictureToByte,
      filename: 'review_img_$reviewId.jpg', // use the real name if available, or omit
      contentType: MediaType('image', 'png'),
    );

    final formData = FormData.fromMap({
      "review_img": multiPartData,
      "review": reviewId,
    });

    final sendingPictureResponse = await Dio().post(
      '$REQUEST_URL/board/review-img',
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/octet-stream",
          "Authorization": "Bearer ${TokenService().accessToken!}",
        },
      ),
    );

    print('status: ${sendingPictureResponse.statusCode}');

    return sendingPictureResponse.statusCode!;
  }
}