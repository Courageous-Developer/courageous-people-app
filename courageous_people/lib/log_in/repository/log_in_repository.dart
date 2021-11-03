import 'dart:convert';

import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LogInRepository {
  Future<int> logIn(BuildContext context, String email, String password) async {
    http.Response response = await httpRequestWithoutToken(
      requestType: 'POST',
      path: '/account/login',
      body: {
        "email": email,
        "password": digest(password),
      },
    );

    print(password);
    print(digest(password));

    final result = jsonDecode(response.body);

    if(response.statusCode == 200) {
      await TokenService().setTokens(
        result['access'],
        result['refresh'],
      );

      await UserHive().setEmail(email);
    }

    return response.statusCode;
  }

  String digest(String password) => Crypt.sha256(password).toString();
}