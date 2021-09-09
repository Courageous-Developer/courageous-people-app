import 'dart:convert';

import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/common/hive/token_hive.dart';
import 'package:courageous_people/service/token_service.dart';
import 'package:http/http.dart' as http;


Future<bool> isUserVerified() async {
  final http.Response refreshTokenResponse = await http.post(
      Uri.parse('$AUTH_RELATED_SERVER_URL/verify'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "token": TokenHive().refreshToken
      })
  );

  if (refreshTokenResponse.statusCode != 200) return false;

  final http.Response getAccessTokenResponse = await http.post(
      Uri.parse('$AUTH_RELATED_SERVER_URL/refresh'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "refresh": TokenHive().refreshToken!
      })
  );

  if(getAccessTokenResponse.statusCode != 200)  return false;

  TokenService().setAccessToken(jsonDecode(getAccessTokenResponse.body)['access']);
  return true;
}