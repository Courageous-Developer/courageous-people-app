import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/utils/interpreters.dart';
import 'package:http/http.dart' as http;
import '../../common/classes.dart';
import 'package:courageous_people/common/mock_data.dart';

import 'dart:convert';

class StoreRepository {
  Future<List<Stores>> getStores() async {
    http.Response response = await http.get(
      Uri.parse('$NON_AUTH_SERVER_URL/store'),
      headers: {"Accept": "application/json"},
    );

    return storeInterpret(response.body);
  }
}