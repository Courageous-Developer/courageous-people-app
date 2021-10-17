import 'dart:convert';

import '../model/store_data.dart';
import '../model/user_data.dart';
import '../model/review_data.dart';
import '../model/tag_data.dart';
import '../common/classes.dart';

List<StoreData> storeInterpret(String source) {
  final List<dynamic> dataList = jsonDecode(source);

  final storeList = dataList.map(
          (data) {
        Json store = data;

        return StoreData(
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

UserData userInterpret(String source) {
  final dynamic data = jsonDecode(source);
  final Json user = data;

  return UserData(
    user['id'],    //user['id'],
    user['nickname'],   // user['nickname'],
    user['email'],
    user['user_type'],
  );
}

List<ReviewData> reviewInterpret(String source) {
  final List<dynamic> dataList = jsonDecode(source);

  final reviewList = dataList.map(
          (data) {
        Json review = data;

        return ReviewData(
          review['id'],
          review['store'],
          review['nickname'],
          review['content'],
          review['insrt_dt'],
          (review['review_img'] as List<dynamic>).map(
              (data) => data['review_img'] as String
          ).toList(),
          tagInterpreter(jsonEncode(review['tag'])),
        );
      }
  ).toList();

  return reviewList;
}

List<TagData> tagInterpreter(String source) {
  final List<dynamic> dataList = jsonDecode(source);
  if(dataList.length == 0)  return [];

  final tagList = dataList.map(
          (data) {
        Json tag = data;

        return TagData(
          tag['tag_content'],
          tag['color_index'],
        );
      }
  ).toList();

  return tagList;
}