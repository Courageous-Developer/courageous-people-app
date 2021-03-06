import 'dart:convert';

import 'package:courageous_people/model/menu_data.dart';

import '../model/store_data.dart';
import '../model/user_data.dart';
import '../model/review_data.dart';
import '../model/tag_data.dart';
import '../common/classes.dart';

List<StoreData> toStoreList(String source) {
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
          toImageList(jsonEncode(store['store_img'])),
          toMenuList(jsonEncode(store['menu'])),
        );
      }
  ).toList();

  return storeList;
}

UserData toUser(String source) {
  final dynamic data = jsonDecode(source);
  final Json user = data;

  return UserData(
    user['id'],
    user['nickname'],
    user['email'],
    user['user_type'],
  );
}

List<ReviewData> toReviewList(String source) {
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
          toTagList(jsonEncode(review['tag'])),
        );
      }
  ).toList();

  return reviewList;
}

List<TagData> toTagList(String source) {
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

List<MenuData> toMenuList(String source) {
  final List<dynamic> dataList = jsonDecode(source);

  if(dataList.length == 0)  return [];

  final menuList = dataList.map(
          (data) {
        Json menu = data;

        final List<dynamic> menuImageList = menu['menu_img'];
        String? imageUrl;

        if(menuImageList.length > 0) {
          imageUrl = menuImageList[0]['menu_img'];
        }

        return MenuData(
          menu['menu'] ?? '',
          menu['price'] ?? '',
          menu['store'],
          imageUrl,
        );
      }
  ).toList();

  return menuList;
}

StoreData toStore(String source) {
  final Json store = jsonDecode(source);

  return StoreData(
    store['id'],
    store['store_name'],
    store['address'],
    store['post'],
    double.parse(store['latitude']),
    double.parse(store['longitude']),
    store['biz_num'],
    toImageList(jsonEncode(store['store_img'])),
    toMenuList(jsonEncode(store['menu'])),
  );
}

List<String> toImageList(String source) {
  final List<dynamic> dataList = jsonDecode(source);

  if(dataList.length == 0)  return [];

  final imageList = dataList.map(
          (data) {
        Json imageUrl = data;

        final String image = imageUrl['store_img'];
        return image;
      }
  ).toList();

  return imageList;
}