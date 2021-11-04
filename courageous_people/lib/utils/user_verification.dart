import 'dart:convert';

import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:courageous_people/utils/interpreters.dart';
import 'package:http/http.dart' as http;

Future<bool> getAuthorization() async {
  final refreshToken = TokenService().refreshToken;
  final noRefreshToken = refreshToken == null || refreshToken == '';
  if(noRefreshToken) return false;

  final isRefreshTokenVerified = await _verifyRefreshToken(refreshToken!);
  if(!isRefreshTokenVerified) return false;

  final isRefreshed = await _refresh(refreshToken);
  if(!isRefreshed)  return false;

  return true;
}

Future<bool> verifyUser() async {
  final refreshToken = TokenService().refreshToken;
  final noRefreshToken = refreshToken == null || refreshToken == '';
  if(noRefreshToken) return false;

  final isRefreshTokenVerified = await _verifyRefreshToken(refreshToken!);

  if(!isRefreshTokenVerified) {
    await TokenService().clearTokens();
    await UserHive().clearUser();
    return false;
  }

  final userEmail = UserHive().userEmail;

  final setUserSucceed = await _setUser(userEmail ?? '');
  if(!setUserSucceed) return false;

  return true;
}

Future<bool> _verifyRefreshToken(String refreshToken) async {
  final response = await httpRequestWithoutToken(
    requestType: 'post',
    path: '/account/verify',
    body: {
      "token": refreshToken,
    },
  );

  print('verify response code: ${response.statusCode}');

  if(response.statusCode != 200) return false;
  return true;
}

Future<bool> _refresh(String refreshToken) async {
  final response = await httpRequestWithoutToken(
    requestType: 'post',
    path: '/account/refresh',
    body: {
      "refresh": refreshToken,
    },
  );

  print('refresh response code: ${response.statusCode}');

  if(response.statusCode != 200) return false;

  await TokenService().setAccessToken(jsonDecode(response.body)['access']);
  return true;
}

Future<bool> _setUser(String email) async {
  if(email == '') return false;

  final response = await httpRequestWithToken(
    requestType: 'GET',
    path: '/account/user?email=$email',
  );

  if(response.statusCode != 200) return false;

  print('user response: ${response.statusCode}');
  print('user response: ${response.body}');

  final userData = toUser(response.body);
  UserHive().setUser(userData);

  return true;
}