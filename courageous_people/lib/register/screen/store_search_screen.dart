import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/register/screen/store_add_screen.dart';
import 'package:courageous_people/widget/my_input_form.dart';
import 'package:courageous_people/widget/store_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import '../../widget/transparent_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../common/classes.dart';

class StoreSearchScreen extends StatefulWidget {
  const StoreSearchScreen({Key? key}) : super(key: key);

  @override
  _StoreSearchScreenState createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends State<StoreSearchScreen> {
  late List<dynamic> crawledStoreData;
  late List<bool> isSelectedList = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();

    crawledStoreData = [];
  }

  @override
  Widget build(BuildContext context) {
    final storeSearchInputController = TextEditingController();

    return Scaffold(
      appBar: TransparentAppBar(
        title: '가게 찾기',
        // todo: ios 스타일 사용 X
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Flexible(
              child: Container(
                child: Column(
                  children: [
                    MyInputForm(
                      controller: storeSearchInputController,
                      additionalButton: ElevatedButton(
                        onPressed: () async {
                          String url = 'https://openapi.naver.com/v1/search/local.json';
                          String queryString =
                              "?query=${storeSearchInputController
                              .text}&display=10&start=1&sort=random";
                          http.Response response = await http.get(
                            Uri.parse('$url$queryString'),
                            headers: {
                              "X-Naver-Client-Id": NAVER_API_CLINET_ID,
                              "X-Naver-Client-Secret": NAVER_API_CLINET_SECRET
                            },
                          );

                          setState(() {
                            crawledStoreData = jsonDecode(response.body)['items'];
                          });
                        },
                        child: Text('검색'),
                      ),
                    ),
                    SizedBox(height: 30),
                    Expanded(child: NaverMap()),
                  ],
                ),
              ),
              flex: 1,
            ),
            Flexible(
              child: Center(
                child: crawledStoreData.length != 0
                    ? ListView.separated(
                  itemCount: crawledStoreData.length,
                  itemBuilder:
                      (context, index) =>
                      _searchList(
                        context,
                        crawledStoreData[index],
                        index,
                      ),
                  separatorBuilder: (context, index) => Divider(thickness: 1),
                )
                    : Text('검색 결과가 없습니다'),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchList(
      BuildContext context,
      Map<String, dynamic> crawledData,
      int index
      ) {
    crawledData['title'] = _pureTitle(crawledData['title']);

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelectedList = [false, false, false, false, false,];
          isSelectedList[index] = true;
        });

        showBottomSheet(
          context: context,
          builder: (_) => _registerButton(crawledData),
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

  String _pureTitle(String title) {
    final first = title.split('<b>');
    if (first.length == 1) return first[0];

    final second = first[1].split('</b>');
    return '${first[0]}${second[0]}${second[1]}';
  }

  Widget _registerButton(Map<String,dynamic> storeData) {
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
}