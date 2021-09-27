import 'dart:convert';

import 'package:courageous_people/common/hive/token_hive.dart';
import 'package:courageous_people/common/mock_data.dart';
import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../model/user_data.dart';
import '../../common/constants.dart';
import 'package:http/http.dart' as http;
import '../../model/token.dart';

class LogInRepository {
  Future<bool> logIn(BuildContext context, String email, String password) async {
    final tokenService = context.read<TokenService>();

    // http.Response response = await http.post(
    //     Uri.parse('$AUTH_SERVER_URL/login'),
    //     headers: {
    //       'Accept': 'application/json',
    //       'Content-Type': 'application/json'
    //     },
    //     body: jsonEncode({
    //       "email": email,
    //       "password": password,
    //     })
    // );

    http.Response response = await authHttpRequest(
      requestType: 'POST',
      path: '/login',
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: {
        "email": email,
        "password": password,
      },
    );

    print(response.body);
    final result = jsonDecode(response.body);

    if(response.statusCode == 200) {
      await TokenService().setTokens(
        result['access'],
        result['refresh'],
      );

      return true;
    }

    return false;
  }
}