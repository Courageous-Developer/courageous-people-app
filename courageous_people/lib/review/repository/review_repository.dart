import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../model/review_data.dart';
import '../../common/constants.dart';
import '../../utils/interpreters.dart';

class ReviewRepository {
  Future<List<ReviewData>> getReviews(int storeId) async {
    final response = await httpRequestWithoutToken(
      requestType: 'GET',
      path: '/board/review/$storeId',
    );

    return toReviewList(response.body);
  }

  Future<int> addReview({
    required int storeId,
    required int userId,
    required String menu,
    required String container,
    required String comment,
    Uint8List? pictureToByte,
  }) async {
    final addingReviewResponse = await httpRequestWithToken(
      requestType: 'POST',
      path: '/board/review',
      body: {
        'user': userId,
        'store': storeId,
        'content': comment,
        'tag': [
          {
            'tag_content': menu,
            'type': 1,
            'color_index': Random().nextInt(8),
          },
          {
            'tag_content': container,
            'type': 2,
            'color_index': Random().nextInt(8),
          },
        ],
      },
    );

    print('review add statusCode: ${addingReviewResponse.statusCode}');
    print('review add body: ${addingReviewResponse.body}');

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

    print('review image add status: ${sendingPictureResponse.statusCode}');
    print('review image add body: ${sendingPictureResponse.data}');

    return sendingPictureResponse.statusCode!;
  }
}