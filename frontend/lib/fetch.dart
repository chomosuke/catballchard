import 'package:http/http.dart' as http;

final Uri baseUri = Uri.base.resolve('../');
final Uri apiUri = baseUri.resolve('api/');

Future<String> getHello() async {
  final response = await http.get(apiUri.resolve('hello'));
  return response.body;
}
