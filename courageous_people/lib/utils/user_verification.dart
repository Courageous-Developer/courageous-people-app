import 'dart:convert';

import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:courageous_people/utils/interpreters.dart';
import 'package:http/http.dart' as http;

Future<bool> isUserVerified() async {
  final refreshToken = TokenService().refreshToken;
  final noRefreshToken = refreshToken == null || refreshToken == '';

  if(noRefreshToken) return false;

  final refreshTokenResponse = await httpRequestWithoutToken(
    requestType: 'post',
    path: '/account/verify',
    body: {
      "token": refreshToken,
    },
  );

  print('verify response code: ${refreshTokenResponse.statusCode}');
  if (refreshTokenResponse.statusCode != 200) return false;

  final getAccessTokenResponse = await httpRequestWithoutToken(
    requestType: 'post',
    path: '/account/refresh',
    body: {
      "refresh": refreshToken,
    },
  );

  if(getAccessTokenResponse.statusCode != 200)  return false;

  await TokenService().setAccessToken(
    jsonDecode(getAccessTokenResponse.body)['access'],
  );

  final userEmail = UserHive().userEmail;

  if(userEmail != null || userEmail != '') {
    final getUserResponse = await httpRequestWithToken(
      requestType: 'GET',
      path: '/account/user?email=$userEmail',
    );

    print('refresh code: ${getUserResponse.statusCode}');

    final userData = userInterpret(getUserResponse.body);
    UserHive().setUser(userData);
  }

  return true;
}