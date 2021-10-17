import 'dart:io';

import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/utils/interpreters.dart';
// import 'package:http/http.dart' as http;
import '../../utils/http_client.dart';

class StoreRepository {
  Future<List<StoreData>> getStores() async {
    return storeInterpret((await httpRequestWithoutToken(
        requestType: 'GET', path: '/board/store'))
        .body);
  }

  Future<bool> addStore(
      String storeName, String address, String post,
      String? imageUrl, double latitude, double longitude, int registrant
      ) async {
    final response =  await httpRequestWithToken(
      requestType: 'POST',
      path: '/board/store',
      body: {
        "store_name": storeName,
        "address": address,
        "post": post,
        "picture": imageUrl ?? '',  // todo: image url 추가
        "latitude": latitude,
        "longitude": longitude,
        "user": registrant,
      },
    );

    if(response.statusCode == 201)  return true;
    return false;
  }
}