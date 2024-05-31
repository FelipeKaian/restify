// ignore_for_file: public_member_api_docs, sort_constructors_first
library restify;

import 'dart:convert';

import 'package:http/http.dart' as http;

class Restify {
  String baseUrl;
  bool decodeUTF8;
  String? _authorization;

  Restify(
    this.baseUrl, {
    this.decodeUTF8 = false,
  });

  void setAuthorization(String authorization) {
    _authorization = authorization;
  }

  Future<T> get<T>(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParams,
      dynamic body,
      MultipartFile? multipartFile,
      T Function(dynamic json)? fromMap}) async {
    return request(
      url,
      requestType: RequestType.GET,
      headers: headers,
      body: body,
      fromMap: fromMap,
      queryParams: queryParams,
      multipartFile: multipartFile,
    );
  }

  Future<T> post<T>(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParams,
      dynamic body,
      MultipartFile? multipartFile,
      T Function(dynamic json)? fromMap}) async {
    return request(
      url,
      requestType: RequestType.POST,
      headers: headers,
      body: body,
      fromMap: fromMap,
      queryParams: queryParams,
      multipartFile: multipartFile,
    );
  }

  Future<T> put<T>(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParams,
      dynamic body,
      MultipartFile? multipartFile,
      T Function(dynamic json)? fromMap}) async {
    return request(
      url,
      requestType: RequestType.PUT,
      headers: headers,
      body: body,
      fromMap: fromMap,
      queryParams: queryParams,
      multipartFile: multipartFile,
    );
  }

  Future<T> delete<T>(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParams,
      dynamic body,
      MultipartFile? multipartFile,
      T Function(dynamic json)? fromMap}) async {
    return request(
      url,
      requestType: RequestType.DELETE,
      headers: headers,
      body: body,
      fromMap: fromMap,
      queryParams: queryParams,
      multipartFile: multipartFile,
    );
  }

  Future<T> patch<T>(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParams,
      dynamic body,
      MultipartFile? multipartFile,
      T Function(dynamic json)? fromMap}) async {
    return request(
      url,
      requestType: RequestType.PATCH,
      headers: headers,
      body: body,
      fromMap: fromMap,
      queryParams: queryParams,
      multipartFile: multipartFile,
    );
  }

  Future<T> request<T>(String url,
      {required RequestType requestType,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParams,
      dynamic body,
      MultipartFile? multipartFile,
      T Function(dynamic json)? fromMap}) async {
    try {
      headers ??= <String, String>{};

      headers['Content-Type'] = 'application/json';

      if (_authorization != null) {
        headers['Authorization'] = _authorization!;
      }

      url = baseUrl + url;

      if (queryParams != null) {
        url += queryParamsConverter(queryParams);
      }

      if (body is! String) {
        body = json.encode(body);
      }

      if (multipartFile != null) {
        var request =
            http.MultipartRequest(requestType.toString(), Uri.parse(url));
        request.files.add(multipartFile);
        http.StreamedResponse streamedResponse = await request.send();
        String responseObject = await streamedResponse.stream.bytesToString();
        if (streamedResponse.statusCode >= 200 &&
            streamedResponse.statusCode < 300) {
          dynamic jsonData;
          if (fromMap != null) {
            if (decodeUTF8) {
              try {
                responseObject = utf8.decode(responseObject.codeUnits);
              } catch (e) {
                throw Exception("Erro na conversão do UTF8: $e");
              }
            }
            try {
              jsonData = fromMap(json.decode(responseObject));
              print(
                  "calling $url -> ${responseObject.length > 1000 ? "${responseObject.substring(0, 1000)}..." : responseObject}");
              return jsonData;
            } catch (e) {
              throw Exception("Erro na conversão do body: $e");
            }
          } else {
            return jsonData;
          }
        } else {
          throw Exception(responseObject);
        }
      } else {
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

        if (response.statusCode >= 200 && response.statusCode < 300) {
          String responseObject = response.body;
          dynamic jsonData;
          if (fromMap != null) {
            if (decodeUTF8) {
              try {
                responseObject = utf8.decode(responseObject.codeUnits);
              } catch (e) {
                throw Exception("Erro na conversão do UTF8: $e");
              }
            }
            try {
              jsonData = fromMap(json.decode(responseObject));
              print(
                  "calling $url -> ${response.body.length > 1000 ? "${response.body.substring(0, 1000)}..." : response.body}");
              return jsonData;
            } catch (e) {
              throw Exception("Erro na conversão do body: $e");
            }
          } else {
            return jsonData;
          }
        } else {
          throw Exception(response);
        }
      }
    } catch (e) {
      throw Exception("Retify error: $e");
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
      if (valor is String) {
        queryParams += '$chave=${valor}';
      } else {
        queryParams += '$chave=${jsonEncode(valor)}';
      }
    });
    return Uri.encodeFull(queryParams);
  }
}

class MultipartFile extends http.MultipartFile{
  MultipartFile(super.field, super.stream, super.length);
}

enum RequestType { POST, PUT, GET, DELETE, PATCH }
