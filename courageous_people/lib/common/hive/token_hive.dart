import 'package:hive/hive.dart';

class TokenHive {
  // Singleton
  static late Box<dynamic> _box;

  static final String tokenStore = 'TOKEN_BOX';
  final String _accessTokenKey = "ACCESS_TOKEN";
  final String _refreshTokenKey = "REFRESH_TOKEN";

  static final TokenHive _tokenHive = TokenHive._();
  factory TokenHive() => _tokenHive;

  TokenHive._() {
    // 오리지널 생성자
    _box = Hive.box(tokenStore);
  }

  String? get accessToken {
    String? token;
    token = _box.get(_accessTokenKey, defaultValue: null);

    return token;
  }

  String? get refreshToken {
    String? token;
    token = _box.get(_refreshTokenKey, defaultValue: null);

    return token;
  }

  Future<void> setAccessToken(String token) async {
    await _box.put(_accessTokenKey, token);
  }

  Future<void> setRefreshToken(String token) async {
    await _box.put(_refreshTokenKey, token);
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    await setAccessToken(accessToken);
    await setRefreshToken(refreshToken);
  }
}