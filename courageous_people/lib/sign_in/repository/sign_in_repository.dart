import 'package:courageous_people/utils/http_client.dart';
import 'package:crypt/crypt.dart';
import 'package:http/http.dart' as http;

import '../../common/constants.dart';

class SignInRepository {
  Future<int> signIn(
      String nickname,
      String email,
      String password,
      String birthDate,
      int manageFlag
      ) async {
    http.Response response = await httpRequestWithoutToken(
      requestType: 'POST',
      path: '/account/register',
      body: {
        "nickname": nickname,
        "email": email,
        "password": password,
        // "password": digest(password),
        "date_of_birth": birthDate,
        "user_type": manageFlag,
      },
    );

    print(response.statusCode);
    print("body: ${response.body}");

    return response.statusCode;
  }

  Future<int> checkNicknameDuplicated(String nickname) async {
    final response = await httpRequestWithoutToken(
      requestType: 'POST',
      path: '/account/nickname',
      body: {
        "nickname": nickname
      },
    );

    return response.statusCode;
  }

  Future<int> checkRegisterNumber(String registerNumber) async {
    final response = await httpRequestWithoutToken(
      requestType: 'POST',
      path: '/board/biz-auth',
      body: {
        "biz_num": registerNumber,
      },
    );

    print(response.statusCode);
    print(response.body);

    return response.statusCode;
  }

  String digest(String password) => Crypt.sha256(password, salt: SALT).toString();
}