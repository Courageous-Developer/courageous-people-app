import 'dart:convert';

import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/utils/http_client.dart';

Future<bool> isUserVerified() async {
  final refreshTokenResponse = await httpRequestWithoutToken(
    requestType: 'post',
    path: '/account/verify',
    body: {
      "token": TokenService().refreshToken
    },
  );

  if (refreshTokenResponse.statusCode != 200) return false;

  final getAccessTokenResponse = await httpRequestWithoutToken(
    requestType: 'post',
    path: '/account/refresh',
    body: {
      "refresh": TokenService().refreshToken
    },
  );

  if(getAccessTokenResponse.statusCode != 200)  return false;

  await TokenService().setAccessToken(
    jsonDecode(getAccessTokenResponse.body)['access'],
  );

  return true;
}