import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/register/screen/store_add_screen.dart';
import 'package:courageous_people/utils/get_widget_information.dart';
import 'package:courageous_people/widget/my_drop_down.dart';
import 'package:courageous_people/widget/my_input_form.dart';
import 'package:courageous_people/widget/store_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import '../../widget/transparent_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../common/classes.dart';
import '../../utils/http_client.dart';
import '../../model/store_data.dart';

class StoreSearchScreen extends StatefulWidget {
  const StoreSearchScreen({Key? key}) : super(key: key);

  @override
  _StoreSearchScreenState createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends State<StoreSearchScreen> {
  late List<dynamic> crawledStoreData;
  late List<bool> isSelectedList = [false, false, false, false, false];
  late List<Marker> markerList;
  late List<Stores> storeList;
  //  todo: 마커 리스트 생성

  @override
  void initState() {
    super.initState();

    crawledStoreData = [];
    markerList = [];
    storeList = [];
  }

  @override
  Widget build(BuildContext context) {
    final storeSearchInputController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _locationSelectList(),
                        MyInputForm(
                          title: Text('가게 이름을 입력해주세요'),
                          controller: storeSearchInputController,
                          additionalButton: ElevatedButton(
                            onPressed: () async {
                              String queryString =
                                  "?query=${storeSearchInputController.text}"
                                  "&display=10&start=1&sort=random";

                              final response = await naverRequestResponse(
                                requestApi: 'place',
                                url: PLACE_SEARCH_REQUEST_URL,
                                queryString: queryString,
                              );

                              crawledStoreData = jsonDecode(response.body)['items'];

                              markerList = [];
                              for(Json data in crawledStoreData) {
                                final index = crawledStoreData.indexOf(data);
                                final latLng = await _addressToLatLng(data['address']);

                                data['latitude'] = latLng.latitude;
                                data['longitude'] = latLng.longitude;

                                crawledStoreData[index] = data;

                                final marker = await toMarker(data);
                                markerList.add(marker);
                              }

                              setState(() {});
                            },
                            child: Text(
                              '검색',
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Expanded(child: NaverMap(
                          markers: markerList,
                        )),
                      ],
                    ),
                  ),
                  Expanded(child: _resultListView(crawledStoreData)),
                ],
              ),
            ),
            Positioned(
              left: 20.0,
              top: 20.0,
              child: FloatingActionButton.small(
                onPressed: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _locationSelectList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('지역을 설정해주세요'),
        Row(
          children: [
            MyDropDown(
              title: '시/도',
              contents: ['aa', 'bb','aa', 'bb','aa', 'bb','aa', 'bb','aa', 'bb'],
            ),
            SizedBox(width: 10),
            MyDropDown(
              title: '구',
              contents: [
                '강동구', '강서구', '강남구', '강북구', '송파구',
                '노원구', '성북구', '성동구', '금천구', '동대문구'
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _resultTile(
      BuildContext context,
      Map<String, dynamic> crawledData,
      int index,
      ) {
    crawledData['title'] = _pureTitle(crawledData['title']);

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelectedList = [false, false, false, false, false];
          isSelectedList[index] = true;
        });

        showBottomSheet(
          context: context,
          builder: (context) => _registerButton(context, crawledData),
        );
      },

      child: Container(
        height: 80,
        color: isSelectedList[index] ? Colors.grey[300] : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      crawledData['title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      crawledData['category'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
              flex: 1,
            ),
            Flexible(
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(crawledData['address']),
              ),
              flex: 1,
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _resultListView(List<dynamic> results) {
    return  Center(
      child: results.length != 0
          ? ListView.separated(
        itemCount: results.length,
        itemBuilder:
            (context, index) =>
            _resultTile(
              context,
              results[index],
              index,
            ),
        separatorBuilder: (context, index) => Divider(thickness: 1),
      )
          : Text('검색 결과가 없습니다'),
    );
  }

  String _pureTitle(String title) {
    final first = title.split('<b>');
    if (first.length == 1) return first[0];

    final second = first[1].split('</b>');
    return '${first[0]}${second[0]}${second[1]}';
  }

  // Future<LatLng> _tm128ToLatLng(
  //     String mapX,
  //     String mapY,
  //     ) async {
  //   print('tm');
  //
  //   final response = await naverRequestResponse(
  //     requestApi: 'gc',
  //     url: REVERSE_GEOCODE_REQUEST_URL,
  //     queryString:
  //     "?request=coordsToaddr&coords=$mapX,$mapY"
  //         "&sourcecrs=nhn:128&targetcrs=epsg:4326&output=json",
  //   );
  //
  //   final aa = jsonDecode(response.body)['results'];
  //
  //
  //   for(int i=0; i<(aa as List<dynamic>).length; i++) {
  //     print('tmtm$i: ');
  //     print(aa[i]);
  //   }
  //
  //   // final decoded = jsonDecode(response.body);
  //   return LatLng(1, 1);
  // }


  Future<LatLng> _addressToLatLng(String address) async {
    final response = await naverRequestResponse(
      requestApi: 'geocode',
      url: GEOCODE_REQUEST_URL,
      queryString:
      "?query=$address",
    );

    final latitude = jsonDecode(response.body)['addresses'][0]['y'];
    final longitude = jsonDecode(response.body)['addresses'][0]['x'];

    print('$latitude $longitude');
    print(double.parse(latitude));

    return LatLng(
      double.parse(latitude),
      double.parse(longitude),
    );
  }

  Future<Marker> toMarker(Json data) async {
    return Marker(
      markerId: data['title'],
      position: LatLng(data['latitude'], data['longitude']),
    );
  }
}

Widget _registerButton(BuildContext context, Map<String, dynamic> storeData) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => StoreAddScreen(storeData),
      ));
    },
    child: Container(
      height: 50,
      color: Colors.green,
      child: Center(
        child:
        Text(
          '등록하기',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16
          ),
        ),
      ),
    ),
  );
}

class _Content extends HookWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
