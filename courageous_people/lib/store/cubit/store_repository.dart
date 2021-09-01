import 'package:courageous_people/model/store_data.dart';
import 'package:http/http.dart' as http;
import '../../classes.dart';
import 'package:courageous_people/mock_data.dart';

class StoreRepository {
  Future<List<Store>> getStores() async {
    await Future.delayed(Duration(seconds: 1));
    final result = StoreMockData.storeJson;

    final resultMap = result.map(
            (store) => Store(
            store['name'], store['biz_num'], store['intro'], store['lat'],
            store['lng'])
    );

    return resultMap.toList();
  }

// Future<String> getStores() async {
//   http.Response response = await http.get(
//     Uri.parse('http://223.194.46.212:8757/rest_api/bizareas'),
//     headers: {"Accept": "application/json"},
//   );
//
//   print(response.body);
//   return response.body;
// }
}