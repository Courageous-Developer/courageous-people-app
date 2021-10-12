import 'dart:convert';

import '../model/store_data.dart';
import '../model/user_data.dart';
import '../model/review_data.dart';
import '../model/tag_data.dart';
import '../common/classes.dart';

List<Stores> storeInterpret(String source) {
  final List<dynamic> dataList = jsonDecode(source);

  final storeList = dataList.map(
          (data) {
        Json store = data;

        return Stores(
            store['id'],
            store['store_name'],
            store['address'],
            store['post'],
            double.parse(store['latitude']),
            double.parse(store['longitude']),
            store['biz_num'],
            store['picture']
        );
      }
  ).toList();

  return storeList;
}

User userInterpret(String source) {
  final dynamic data = jsonDecode(source);
  final Json user = data;

  return User(
    user['id'],    //user['id'],
    user['nickname'],   // user['nickname'],
    user['email'],
    user['user_type'],
  );
}

List<Review> reviewInterpret(String source) {
  final List<dynamic> dataList = jsonDecode(source);

  final reviewList = dataList.map(
          (data) {
        Json review = data;

        return Review(
          review['id'],
          review['store'],
          review['nickname'],
          review['content'],
          review['insrt_dt'],
          // review['review_img'],
          // review['tag'],
          [],
          // tagInterpreter(review['tag'].toString())
          // review['tag'].length
          tagInterpreter(jsonEncode(review['tag'])),
        );
      }
  ).toList();

  return reviewList;
}

List<Tag> tagInterpreter(String source) {
  final List<dynamic> dataList = jsonDecode(source);
  if(dataList.length == 0)  return [];

  final tagList = dataList.map(
          (data) {
        Json tag = data;

        return Tag(
          tag['tag_content'],
          tag['color_index'],
        );
      }
  ).toList();

  return tagList;
}