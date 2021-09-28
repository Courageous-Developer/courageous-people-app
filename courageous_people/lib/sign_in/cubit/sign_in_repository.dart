import 'dart:convert';

import 'package:courageous_people/model/user_data.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:courageous_people/utils/interpreters.dart';
import 'package:flutter/cupertino.dart';
import '../../common/constants.dart';
import 'package:http/http.dart' as http;

class SignInRepository {
  // todo: post 요청
  Future<String?> signIn(
      String nickname,
      String email,
      String password,
      String birthDate,
      int manageFlag
      ) async {
    http.Response response = await httpRequestWithoutToken(
      requestType: 'POST',
      path: '/account/register',
      body: {
        "email": "potter@naver.com",
        "nickname": nickname,
        "password": password,
        "date_of_birth": birthDate,
        "user_type": manageFlag.toString(),
      },
    );

    if(response.statusCode == 400) return '이미 사용중인 이메일입니다';
    if(response.statusCode == 201) return null;

    return '잘못된 접근입니다';
  }
}