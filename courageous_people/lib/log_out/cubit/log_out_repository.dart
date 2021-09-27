import 'package:courageous_people/utils/http_client.dart';
import 'package:http/http.dart' as http;

import '../../service/token_service.dart';

class LogOutRepository {
  const LogOutRepository();

  Future<bool> logOut() async {
    final response = await authHttpRequest(
      requestType: 'POST',
      path: '/logout',
      body: {
        "refresh": TokenService().refreshToken,
      },
    );

    if(response.statusCode == 205) {
      await TokenService().setTokens('', '');
      return true;
    }

    return false;
  }
}