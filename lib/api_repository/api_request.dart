import 'dart:convert';

import 'package:ecom_web_flutter/api_repository/models/models.dart';
import 'package:ecom_web_flutter/injector/injector.dart';
import 'package:ecom_web_flutter/storage/shared_preferences_manager.dart';
import 'package:http/http.dart' as http;

Future<T> apiRequest<T, K>(String path,
    {required HttpMethod method,
    bool useToken = false,
    Map? body,
    String? params}) async {
  final SharedPreferencesManager sharedPreferencesManager =
      locator<SharedPreferencesManager>();
  String? token = sharedPreferencesManager
      .getString(SharedPreferencesManager.keyAccessToken);
  String _baseUrl = 'https://api-stg.sevva.co.id/api';
  Map<String, String> Header = useToken
      ? {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'}
      : {'Content-Type': 'application/json'};
  if (params != null) path += params;
  print(method.toShortString() + ': ${_baseUrl + path}');
  if (method.toShortString() == 'GET') {
    final response =
        await http.get(Uri.parse(_baseUrl + path), headers: Header);
    print(response.body);
    T model = Generic.fromJson(json.decode(response.body));
    return model;
  } else {
    print('Body: ${body}');
    final response = await http.post(Uri.parse(_baseUrl + path),
        body: json.encode(body), headers: Header);
    print('Response: ${response.body}');
    print('StatusCode: ${response.statusCode}');
    T model = Generic.fromJson(json.decode(response.body));
    return model;
  }
}

enum HttpMethod { GET, POST }

extension ParseToString on HttpMethod {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class Generic {
  /// If T is a List, K is the subtype of the list.
  static T fromJson<T, K>(dynamic json) {
    if (json is Iterable) {
      return _fromJsonList<K>(json) as T;
    } else if (T == ProductModel) {
      return ProductModel.fromJson(json) as T;
    } else if (T == PostResponseModel) {
      return PostResponseModel.fromJson(json) as T;
    } else if (T == SignInModel) {
      return SignInModel.fromJson(json) as T;
    } else if (T == CartModel) {
      return CartModel.fromJson(json) as T;
    } else if (T == bool || T == String || T == int || T == double) {
      // primitives
      return json;
    } else {
      throw Exception("Unknown class");
    }
  }

  static List<K>? _fromJsonList<K>(Iterable<dynamic> jsonList) {
    return jsonList.map<K>((dynamic json) => fromJson<K, void>(json)).toList();
  }
}
