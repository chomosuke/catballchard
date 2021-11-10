import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

final Uri baseUri =
    kReleaseMode ? Uri.base.resolve('../') : Uri.parse('http://localhost/');
final Uri apiUri = baseUri.resolve('api/');

Future<String> getHello() async {
  final response = await http.get(apiUri.resolve('hello'));
  return response.body;
}
