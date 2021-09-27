import 'dart:convert';

import 'package:courageous_people/common/constants.dart';
import 'package:http/http.dart' as http;
import '../common/classes.dart';
import '../service/token_service.dart';

Future<http.Response> nonAuthHttpRequest({
  required String requestType,
  required String path,
  Map<String, String> headers = const {
    "Accept": "application/json",
    "Content-Type": "application/json",
  },
  Json? body,
  Encoding? encoding,
}) async {
  final uri = Uri.parse('$NON_AUTH_SERVER_URL$path');
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
    headers: headers,
    body: jsonEncode(body),
    encoding: encoding,
  )
      : await requestWithoutBody(
    uri,
    headers: headers,
  );

  return response;
}

Future<http.Response> authHttpRequest({
  required String requestType,
  required String path,
  Map<String, String>? headers,
  Json? body,
  Encoding? encoding,
}) async {
  final uri = Uri.parse('$AUTH_SERVER_URL$path');
  final Future<http.Response> Function(
      Uri, {Map<String, String>? headers}
      ) requestWithoutBody = http.get;
  late Future<http.Response> Function(
      Uri, {Object? body, Encoding? encoding, Map<String, String>? headers}
      ) requestWithBody;

  final headersWithAccessToken = headers ??  {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer ${TokenService().accessToken!}"
  };

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
    headers: headersWithAccessToken,
    body: jsonEncode(body),
    encoding: encoding,
  )
      : await requestWithoutBody(
    uri,
    headers: headersWithAccessToken,
  );

  return response;
}