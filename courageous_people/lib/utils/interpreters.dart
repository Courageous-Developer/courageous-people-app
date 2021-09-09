import 'dart:convert';

import '../model/store_data.dart';
import '../model/user_data.dart';
import '../model/review_data.dart';
import '../common/classes.dart';

List<Stores> storeInterpret(String source) {
  final List<dynamic> dataList = jsonDecode(source);

  final storeList = dataList.map(
          (data) {
        Json store = data;

        return Stores(
            1,
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
    1,    //user['id'],
    'Nickname',   // user['nickname'],
    user['email'],
    user['date_of_birth'],
    user['user_type'],
  );
}

List<Review> reviewInterpret(String source) {
  final List<dynamic> dataList = jsonDecode(source);

  final reviewList = dataList.map(
          (data) {
        Json store = data;

        return Review(
            1,
            store['store_name'],
            store['user_nickname'],
            store['content'],
            store['biz_num'],
            store['picture']
        );
      }
  ).toList();

  return reviewList;
}