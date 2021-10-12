import 'dart:convert';

import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/common/hive/token_hive.dart';
import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/store/cubit/store_cubit.dart';
import 'package:courageous_people/store/cubit/store_state.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:courageous_people/widget/my_input_form.dart';
import 'package:courageous_people/widget/transparent_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

import '../../home.dart';

class StoreAddScreen extends HookWidget {
  final storeData;
  final managerFlag = 1;

  StoreAddScreen(this.storeData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeCubit = StoreCubit.of(context);
    final userId = UserHive().userId;
    final commentNotifier = useState('');
    String? imageUrl;

    return BlocListener<StoreCubit, StoreState>(
      bloc: storeCubit,
      listener: (context, state) async {
        if (state is AddingStoreSuccessState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => Home(isUserVerified: true),
            ),
                (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: TransparentAppBar(title: '가게 등록'),
        body: Stack(
          children: [
            _storeInformationInputSection(context),
            _bottomButton(
              context: context,
              onTap: () async {
                await storeCubit.addStore(
                  storeData['title'],
                  storeData['address'],
                  commentNotifier.value,
                  imageUrl,
                  storeData['latitude'],
                  storeData['longitude'],
                  userId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _storeInformationInputSection(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                : _managerRegisterSection(context),
          ),
          if(managerFlag == 2)  _managerRegisterSection(context),
        ],
      ),
    );
  }

  Widget _bottomButton({
    required BuildContext context,
    required void Function()? onTap,
  }) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: onTap,
        // onTap: () async {
        // final http.Response response = await httpRequestWithToken(
        //   requestType: 'POST',
        //   path: '/board/store',
        //   body: {
        //     "store_name": storeData['title'],
        //     "address": storeData['address'],
        //     "post": "",
        //     "picture": "", // todo: image url 추가
        //     "latitude": storeData['latitude'],
        //     "longitude": storeData['longitude'],
        //     "user": "3",
        //   },
        // );
        //
        // print(response.statusCode);
        // print(response.body);

        // if (response.statusCode == 201) {
        // },
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

  Widget _managerRegisterSection(BuildContext context) {
    // 사진 올리기 & 메뉴 올리기
    final controller = TextEditingController();
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