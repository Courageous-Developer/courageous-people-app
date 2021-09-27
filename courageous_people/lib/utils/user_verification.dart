import 'dart:convert';

import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/utils/http_client.dart';

Future<bool> isUserVerified() async {
  final refreshTokenResponse = await authHttpRequest(
    requestType: 'post',
    path: '/verify',
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    body: {
      "token": TokenService().refreshToken
    },
  );

  if (refreshTokenResponse.statusCode != 200) return false;

  final getAccessTokenResponse = await authHttpRequest(
    requestType: 'post',
    path: '/refresh',
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    body: {
      "refresh": TokenService().refreshToken
    },
  );

  if(getAccessTokenResponse.statusCode != 200)  return false;

  TokenService().setAccessToken(
    jsonDecode(getAccessTokenResponse.body)['access'],
  );

  return true;
}