library restify;

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Restify {
  static Future<T?> get<T>(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParams,
      dynamic body,
      T Function(dynamic json)? fromMap}) async {
    return request(
      url,
      requestType: RequestType.GET,
      headers: headers,
      body: body,
      fromMap: fromMap,
    );
  }

  static Future<T?> post<T>(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParams,
      dynamic body,
      T Function(dynamic json)? fromMap}) async {
    return request(
      url,
      requestType: RequestType.POST,
      headers: headers,
      body: body,
      fromMap: fromMap,
    );
  }

  static Future<T?> put<T>(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParams,
      dynamic body,
      T Function(dynamic json)? fromMap}) async {
    return request(
      url,
      requestType: RequestType.PUT,
      headers: headers,
      body: body,
      fromMap: fromMap,
    );
  }

  static Future<T?> delete<T>(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParams,
      dynamic body,
      T Function(dynamic json)? fromMap}) async {
    return request(
      url,
      requestType: RequestType.DELETE,
      headers: headers,
      body: body,
      fromMap: fromMap,
    );
  }

  static Future<T?> patch<T>(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParams,
      dynamic body,
      T Function(dynamic json)? fromMap}) async {
    return request(
      url,
      requestType: RequestType.PATCH,
      headers: headers,
      body: body,
      fromMap: fromMap,
    );
  }

  static Future<T?> request<T>(String url,
      {required RequestType requestType,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParams,
      dynamic body,
      T Function(dynamic json)? fromMap}) async {
    try {
      url = "http://" + url;

      print("calling " + url);

      if (headers == null) {
        headers = <String, String>{};
      }

      headers['Content-Type'] = 'application/json';

      if (queryParams != null) {
        url += queryParamsConverter(queryParams);
      }

      http.Response response;

      switch (requestType) {
        case RequestType.GET:
          response = await http.get(
            Uri.parse(url),
            headers: headers,
          );
          break;
        case RequestType.POST:
          response = await http.post(
            Uri.parse(url),
            headers: headers,
            body: body,
          );
          break;
        case RequestType.PUT:
          response = await http.put(
            Uri.parse(url),
            headers: headers,
            body: body,
          );
          break;
        case RequestType.DELETE:
          response = await http.delete(
            Uri.parse(url),
            headers: headers,
            body: body,
          );
          break;
        case RequestType.PATCH:
          response = await http.patch(
            Uri.parse(url),
            headers: headers,
            body: body,
          );
          break;
      }

      print("Respondeu -> " + response.body.toString());

      if (response.statusCode >= 200 && response.statusCode < 300) {
        String responseObject = response.body;
        if (fromMap != null) {
          dynamic jsonData;
          try {
            jsonData =
                fromMap(json.decode(utf8.decode(responseObject.codeUnits)));
            return jsonData;
          } catch (e) {
            throw Exception("Erro na conversão do body: " + e.toString());
          }
        } else {
          return null;
        }
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (e) {
      throw Exception("Retify error: " + e.toString());
    }
  }

  static String queryParamsConverter(Map<String, dynamic> params) {
    if (params.isEmpty) {
      return "";
    }
    String queryParams = '?';
    params.forEach((chave, valor) {
      if (queryParams.isNotEmpty) {
        queryParams += '&';
      }
      queryParams += '$chave=$valor';
    });
    return queryParams;
  }
}

enum RequestType { POST, PUT, GET, DELETE, PATCH }

