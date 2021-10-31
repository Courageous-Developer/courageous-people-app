import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:http/http.dart' as http;

import '../../service/token_service.dart';

class LogOutRepository {
  const LogOutRepository();

  Future<bool> logOut() async {
    final response = await httpRequestWithToken(
      requestType: 'POST',
      path: '/account/logout',
      body: {
        "refresh": TokenService().refreshToken,
      },
    );

    print('logout response');

    if(response.statusCode == 205) {
      await TokenService().clearTokens();
      await UserHive().clearUser();

      print('logout success');
      print(response.statusCode);
      print(response.body);

      return true;
    }

    print('logout failed');
    print(response.statusCode);
    print(response.body);

    return false;
  }
}