import 'dart:convert';

import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LogInRepository {
  Future<bool> logIn(BuildContext context, String email, String password) async {
    http.Response response = await httpRequestWithoutToken(
      requestType: 'POST',
      path: '/account/login',
      body: {
        "email": email,
        "password": password,
      },
    );

    final result = jsonDecode(response.body);

    if(response.statusCode == 200) {
      await TokenService().setTokens(
        result['access'],
        result['refresh'],
      );

      // todo: 나중에 싱글턴 패턴 수정
      await UserHive().setEmail(email);

      return true;
    }

    return false;
  }
}