import 'dart:convert';

import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/common/hive/token_hive.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:courageous_people/widget/my_input_form.dart';
import 'package:courageous_people/widget/transparent_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../home.dart';

class StoreAddScreen extends StatelessWidget {
  final storeData;
  final managerFlag = 1;

  StoreAddScreen(this.storeData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registerNumberController = TextEditingController();

    return Scaffold(
      appBar: TransparentAppBar(
        title: '가게 등록',
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Container(
                    height: (MediaQuery.of(context).size.height - 80) *0.33,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyInputForm(
                          title: Text('가게 이름 (검색명)'),
                          controller: TextEditingController(),
                          controllerText: storeData['title'],
                          enabled: false,
                          filled: true,
                        ),
                        MyInputForm(
                          title: Text('카테고리'),
                          controller: TextEditingController(),
                          controllerText: storeData['category'],
                          enabled: false,
                          filled: true,
                        ),
                        MyInputForm(
                          title: Text('주소'),
                          controller: TextEditingController(),
                          controllerText: storeData['address'],
                          enabled: false,
                          filled: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: (MediaQuery.of(context).size.height - 80) *0.55,
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 25),
                  child: managerFlag == 1
                      ? _uploadImageSection(context)
                      : _managerRegister(context, registerNumberController,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                // todo: 오류 수정
                final http.Response response = await httpRequestWithToken(
                  requestType: 'POST',
                  path: 'board/store',
                  body: {
                    "store_name": storeData['title'],
                    "address": storeData['address'],
                    "post": "",
                    "picture": "",  // todo: image url 추가
                    "latitude": "126.11111",
                    "longitude": "37.111111",
                    "user": "3",
                  },
                );

                print(response.body);
                print(response.statusCode);

                if(response.statusCode == 201) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => Home(isUserVerified: true),
                  ));
                }
              },
              child: Container(
                height: 50,
                color: THEME_COLOR,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadImageSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // todo: 카메라/앨범 실행
      },
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Divider(thickness: 1, color: Colors.black)),
                SizedBox(width: 5),
                Text('가게 사진 등록 (최대 1장)'),
                SizedBox(width: 5),
                Expanded(child: Divider(thickness: 1, color: Colors.black)),
              ],
            ),
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(30),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.66,
                  height: MediaQuery.of(context).size.width*0.66,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Text(
                        "No Image",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.grey,
                        ),

                      ),
                      Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.grey,
                          size: MediaQuery.of(context).size.width/5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _managerRegister(BuildContext context, TextEditingController controller) {
    // 사진 올리기 & 메뉴 올리기
    return Container(
      child: Column(
        children: [
          MyInputForm(
            title: Text('사업자 등록 번호'),
            additionalButton: ElevatedButton(
              onPressed: () async {
                // todo: 사업자 등록 번호 인증
              },
              child: Text('인증'),
            ),
            controller: controller,
          ),
          _uploadImageSection(context),
        ],
      ),
    );
  }
}

// return Container(
// child: Column(
// children: [
// Flexible(
// child: Container(
// alignment: Alignment.bottomCenter,
// child: Text(
// storeData['title'],
// style: TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 30,
// color: Colors.white,
// ),
// ),
// ),
// flex: 1,
// ),
// Flexible(
// child: Container(
// alignment: Alignment.bottomCenter,
// child: TagWidget(
// content: storeData['category'],
// color: Colors.amber.shade900,
// ),
// ),
// flex: 1,
// ),
// Flexible(
// child: Container(
// alignment: Alignment.center,
// child: TagWidget(
// content: storeData['address'],
// color: Colors.amber.shade900,
// ),
// ),
// flex: 1,
// ),
// ],
// ),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.all(Radius.circular(20.0)),
// color: Colors.yellow.shade700,
// ),
// );