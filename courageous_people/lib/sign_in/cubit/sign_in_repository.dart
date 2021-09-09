import 'package:courageous_people/common/mock_data.dart';
import 'package:courageous_people/model/user_data.dart';
import 'package:courageous_people/utils/interpreters.dart';
import 'package:flutter/cupertino.dart';
import '../../common/constants.dart';
import 'package:http/http.dart' as http;

class SignInRepository {
  // todo: post 요청
  Future<User> signIn(
      String nickname,
      String email,
      String password,
      String birthDate,
      int manageFlag
      ) async {

    print('aaaaaaaaaaaaaaa');

    print('$email ${email.runtimeType}');
    print('$nickname ${nickname.runtimeType}');
    print('$password ${password.runtimeType}');
    print('$birthDate ${birthDate.runtimeType}');
    print('$manageFlag ${manageFlag.runtimeType}');
    // 보낼 데이터
    http.Response response = await http.post(
      Uri.parse('$NON_AUTH_SERVER_URL/register'),
      headers: {"Accept": "application/json"},
      body: {
        "email": email,
        "nickname": nickname,
        "password": password,
        "date_of_birth": birthDate,
        "user_type": manageFlag,
      },
    );

    print(response.statusCode);
    // 받은 데이터
    return userInterpret(response.body);
  }
}