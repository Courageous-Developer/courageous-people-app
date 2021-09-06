import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/service/token_service.dart';
import 'package:http/http.dart' as http;


Future<bool> isUserVerified() async {
  // return await _isAccessTokenVerified(TokenService().accessToken!) ||
  //     await _isRefreshTokenVerified(TokenService().refreshToken!);
  return true;
}

Future<bool> _isAccessTokenVerified(String accessToken) async {
  final http.Response response = await http.post(
    // todo: url 확인
      Uri.parse('$AUTH_RELATED_SERVER_URL/verify'),
      headers: {
        "Accept": "application/json"
      },
      body: {
        "access_token": accessToken
      }
  );

  if(response.statusCode == 200)  return true;
  return false;
}

Future<bool> _isRefreshTokenVerified(String refreshToken) async {
  final http.Response refreshTokenResponse = await http.post(
      Uri.parse('$AUTH_RELATED_SERVER_URL/verify'),
      headers: {
        "Accept": "application/json"
      },
      body: {
        "refresh_token": refreshToken
      }
  );

  if(refreshTokenResponse.statusCode == 200) {
    final http.Response getAccessTokenResponse = await http.post(
        Uri.parse('$AUTH_RELATED_SERVER_URL/refresh'),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "refresh_token": refreshToken
        }
    );

    // todo: 객체 or String?
    if(getAccessTokenResponse.statusCode == 200) {
      //todo: 토큰 저장
      print(getAccessTokenResponse.body);
      return true;
    }

    // todo: 새 토큰 발급 에러
    return false;
  }

  return false;
}