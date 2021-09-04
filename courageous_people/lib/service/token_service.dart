import 'package:courageous_people/common/hive/token_hive.dart';

import '../model/token.dart';

class TokenService {
  late Token _token;

  TokenService() :
        _token = Token(TokenHive().accessToken, TokenHive().refreshToken);

  String? get accessToken => _token.accessToken;
  String? get refreshToken => _token.refreshToken;

  Future<void> setAccessToken(String token) async {
    await TokenHive().setAccessToken(token);
  }

  Future<void> setRefreshToken(String token) async {
    await TokenHive().setRefreshToken(token);
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    await TokenHive().setTokens(accessToken, refreshToken);
  }
}