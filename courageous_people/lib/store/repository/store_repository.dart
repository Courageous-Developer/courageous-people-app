import 'dart:convert';
import 'dart:typed_data';

import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/utils/interpreters.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import '../../utils/http_client.dart';

class StoreRepository {
  Future<List<StoreData>> getStores() async {
    final response = await httpRequestWithoutToken(
      requestType: 'GET',
      path: '/board/store',
    );

    print(response.body);

    return storeInterpret(response.body);
  }

  Future<int> addStore(
      String storeName, String address, String post,
      Uint8List? imageToByte, double latitude, double longitude,
      int registrant, int managerFlag, List<Map<String, dynamic>> menuList,
      ) async {
    final addStoreResponse =  await httpRequestWithToken(
      requestType: 'POST',
      path: '/board/store',
      body: {
        "store_name": storeName,
        "address": address,
        "post": post,
        "latitude": latitude,
        "longitude": longitude,
        "user": registrant,
      },
    );

    print('store add code: ${addStoreResponse.statusCode}');
    print('store add body: ${addStoreResponse.body}');

    if(addStoreResponse.statusCode != 201) return addStoreResponse.statusCode;

    final storeId = jsonDecode(addStoreResponse.body)['id'];

    if(imageToByte != null) {
      final multiPartData = MultipartFile.fromBytes(
        imageToByte,
        filename: 'store_img_$storeId.jpg',
        // use the real name if available, or omit
        contentType: MediaType('image', 'png'),
      );

      final formData = FormData.fromMap({
        "store_img": multiPartData,
        "store": storeId,
      });

      final sendingPictureResponse = await Dio().post(
        '$REQUEST_URL/board/store-img',
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/octet-stream",
            "Authorization": "Bearer ${TokenService().accessToken!}",
          },
        ),
      );

      print('code: ${sendingPictureResponse.statusCode}');
      print('body: ${sendingPictureResponse.data}');

      if (sendingPictureResponse.statusCode != 201) {
        return sendingPictureResponse.statusCode!;
      }
    }

    for(Map<String, dynamic> menuData in menuList) {
      print('menu start');
      final menuResponse = await addMenu(storeId, menuData);
      print('menu response code: $menuResponse');
      print('menu finished');
    }

    // todo: (수정사항 아님) 메뉴 post 오류 무시

    return 201;
  }

  Future<List<dynamic>> crawlStore(
      String location,
      String storeName,
      ) async {
    String queryString =
        "?query=$location$storeName&display=10&start=1&sort=random";

    final response = await naverRequestResponse(
      requestApi: 'place',
      url: PLACE_SEARCH_REQUEST_URL,
      queryString: queryString,
    );

    final crawledStoreData = jsonDecode(response.body)['items'];

    // for(int index = 0; index < (crawledStoreData as List).length; index++) {
    //   crawledStoreData[index]['title'] = _pureTitle(crawledStoreData[index]['title']);
    //
    //   final duplicatedChecker = await _checkStoreDuplicated(
    //     crawledStoreData[index]['title'],
    //     crawledStoreData[index]['address'],
    //   );
    //
    //   crawledStoreData[index]['duplicated'] = duplicatedChecker == 200
    //       ? true
    //       : false;
    //
    //   final storePosition = await _addressToLatLng(
    //     crawledStoreData[index]['address'],
    //   );
    //
    //   crawledStoreData[index]['latitude'] = storePosition.latitude;
    //   crawledStoreData[index]['longitude'] = storePosition.longitude;
    // }

    for(dynamic data in crawledStoreData) {
      final List<dynamic> crawledStoreList = crawledStoreData;
      final index = crawledStoreList.indexOf(data);

      crawledStoreData[index]['title'] = _pureTitle(data['title']);

      final duplicatedChecker = await _checkStoreDuplicated(
        data['title'],
        data['address'],
      );

      crawledStoreData[index]['duplicated'] = duplicatedChecker == 200
          ? true
          : false;

      final storePosition = await _addressToLatLng(data['address']);

      crawledStoreData[index]['latitude'] = storePosition.latitude;
      crawledStoreData[index]['longitude'] = storePosition.longitude;
    }

    return crawledStoreData;
  }

  Future<int> addMenu(
      int storeId,
      Map<String, dynamic> menuMap,
      ) async {
    print('add menu');

    final String menuName = menuMap['name'];
    final String menuPrice = menuMap['price'];
    final Uint8List? menuImageByte = menuMap['imageByte'];

    final menuResponse = await httpRequestWithToken(
      requestType: 'POST',
      path: '/board/menu',
      body: {
        'menu': menuName,
        'price': menuPrice,
        'store': storeId,
      },
    );

    print('menu response code: ${menuResponse.body}');
    print('menu response code: ${menuResponse.statusCode}');

    if (menuImageByte == null || menuResponse.statusCode != 201) {
      return menuResponse.statusCode;
    }


    final menuId = jsonDecode(menuResponse.body)['id'];

    final multiPartData = MultipartFile.fromBytes(
      menuImageByte,
      filename: 'menu_img_${storeId}_$menuId.jpg',
      // use the real name if available, or omit
      contentType: MediaType('image', 'png'),
    );

    final formData = FormData.fromMap({
      "menu_img": multiPartData,
      "menu": menuId,
    });

    final sendingPictureResponse = await Dio().post(
      '$REQUEST_URL/board/menu-img',
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/octet-stream",
          "Authorization": "Bearer ${TokenService().accessToken!}",
        },
      ),
    );

    print('menu code: ${sendingPictureResponse.statusCode}');
    print('menu body: ${sendingPictureResponse.data}');

    return sendingPictureResponse.statusCode!;
  }

  Future<int> _checkStoreDuplicated(
      String storeName, String address,
      ) async {
    final response = await httpRequestWithToken(
      requestType: 'POST',
      path: '/board/store-verify',
      body: {
        'store_name': storeName,
        'address': address,
      },
    );

    return response.statusCode;
  }

  String _pureTitle(String title)  {
    String refined = '';

    final bTagSplit = title.split('<b>');
    if (bTagSplit.length == 1) return bTagSplit[0];


    refined = bTagSplit[0];

    for(int index=1; index < bTagSplit.length; index++) {
      final slashBTagSplit = bTagSplit[index].split('</b>');

      refined += (slashBTagSplit[0] + slashBTagSplit[1]);
    }

    return refined;
  }

  Future<LatLng> _addressToLatLng(String address) async {
    final response = await naverRequestResponse(
      requestApi: 'geocode',
      url: GEOCODE_REQUEST_URL,
      queryString:
      "?query=$address",
    );

    final latitude = jsonDecode(response.body)['addresses'][0]['y'];
    final longitude = jsonDecode(response.body)['addresses'][0]['x'];

    return LatLng(
      double.parse(latitude),
      double.parse(longitude),
    );
  }
}

