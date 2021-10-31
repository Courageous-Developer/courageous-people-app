import 'package:courageous_people/model/menu_data.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:courageous_people/utils/interpreters.dart';

class MenuRepository {
  Future<List<MenuData>> getMenu(int storeId) async {
    final response = await httpRequestWithoutToken(
      requestType: 'GET',
      // path: '/board/menu/storeId',
      path: '/board/menu',
    );

    print(response.statusCode);
    print(response.body);

    return toMenuList(response.body);
  }
}