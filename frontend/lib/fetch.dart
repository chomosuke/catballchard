import 'dart:math';

import 'package:http/http.dart' as http;

final String currentBase = Uri.base.toString();
final String baseUrl =
    currentBase.substring(0, currentBase.length - 2) + 'api/';

Future<String> getHello() async {
  final response = await http.get(Uri.parse(baseUrl + 'hello'));
  return response.body;
}
