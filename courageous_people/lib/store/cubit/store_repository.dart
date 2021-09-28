import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/utils/interpreters.dart';
// import 'package:http/http.dart' as http;
import '../../utils/http_client.dart';

class StoreRepository {
  Future<List<Stores>> getStores() async {
    return storeInterpret((await httpRequestWithoutToken(
        requestType: 'GET',
        path: '/board/store'
    )).body);
  }
}