import 'package:courageous_people/common/mock_data.dart';
import 'package:courageous_people/service/token_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../model/user_data.dart';
import '../../common/classes.dart';

class LogInRepository {
  Future<User?> logIn(BuildContext context, String id, String password) async {
    final tokenService = context.read<TokenService>();

    // 요청 보내기
    await Future.delayed(Duration(seconds: 1));
    for(Json user in UserMockData.userJson) {
      if(user['email'] == id && user['password'] == password) {
        await tokenService.setTokens(user['access_token'], user['refresh_token']);

        return User(user['nickName'], user['email']);
      }
    }

    return null;
  }
}