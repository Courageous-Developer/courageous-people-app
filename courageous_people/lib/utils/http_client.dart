import 'dart:convert';

import 'package:courageous_people/common/constants.dart';
import 'package:http/http.dart' as http;
import '../common/classes.dart';
import '../service/token_service.dart';

Future<http.Response> httpRequestWithToken({
  required String requestType,
  required String path,
  Map<String, String>? headers,
  Json? body,
  Encoding? encoding,
}) async {
  final uri = Uri.parse('$REQUEST_URL$path');

  final requestHeaders = headers ?? {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer ${TokenService().accessToken!}",
  };

  final Future<http.Response> Function(
      Uri, {Map<String, String>? headers}
      ) requestWithoutBody = http.get;

  late Future<http.Response> Function(
      Uri, {Object? body, Encoding? encoding, Map<String, String>? headers}
      ) requestWithBody;

  http.Response response;
  bool hasBody = true;

  switch (requestType.toLowerCase()) {
    case 'get':
      hasBody = false;
      break;

    case 'post':
      requestWithBody = http.post;
      break;

    case 'put':
      requestWithBody = http.put;
      break;

    case 'delete':
      requestWithBody = http.delete;
      break;
  }

  response = hasBody
      ? await requestWithBody(
    uri,
    headers: requestHeaders,
    body: jsonEncode(body),
    encoding: encoding,
  )
      : await requestWithoutBody(
    uri,
    headers: requestHeaders,
  );

  return response;
}

Future<http.Response> httpRequestWithoutToken({
  required String requestType,
  required String path,
  Map<String, String>? headers,
  Json? body,
  Encoding? encoding,
}) async {
  final uri = Uri.parse('$REQUEST_URL$path');

  final Map<String, String> requestHeaders = headers ?? {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  final Future<http.Response> Function(
      Uri, {Map<String, String>? headers}
      ) requestWithoutBody = http.get;

  late Future<http.Response> Function(
      Uri, {Object? body, Encoding? encoding, Map<String, String>? headers}
      ) requestWithBody;

  http.Response response;
  bool hasBody = true;

  switch (requestType.toLowerCase()) {
    case 'get':
      hasBody = false;
      break;

    case 'post':
      requestWithBody = http.post;
      break;

    case 'put':
      requestWithBody = http.put;
      break;

    case 'delete':
      requestWithBody = http.delete;
      break;
  }

  response = hasBody
      ? await requestWithBody(
    uri,
    headers: requestHeaders,
    body: jsonEncode(body),
    encoding: encoding,
  )
      : await requestWithoutBody(
    uri,
    headers: requestHeaders,
  );

  return response;
}

Future<http.Response> naverRequestResponse({
  required String url,
  required String queryString,
  required String requestApi,
}) async {
  http.Response response = await http.get(
    Uri.parse('$url$queryString'),
    headers: requestApi == 'place'
        ?
    {
      "Accept": "application/json",
      "X-Naver-Client-Id": NAVER_API_CLINET_ID,
      "X-Naver-Client-Secret": NAVER_API_CLINET_SECRET
    }
        :
    {
      "Accept": "application/json",
      "X-NCP-APIGW-API-KEY-ID": X_NCP_APIGW_API_KEY_ID,
      "X-NCP-APIGW-API-KEY": X_NCP_APIGW_API_KEY,
    },
  );

  return response;
}

// todo: http.Response를 반환하지 말고, statuscode에 따른 예외처리 후 json decode 된 객체 반환