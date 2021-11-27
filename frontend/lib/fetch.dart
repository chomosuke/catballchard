import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

final Uri baseUri =
    kReleaseMode ? Uri.base.resolve('../') : Uri.parse('http://localhost/');
final Uri apiUri = baseUri.resolve('api/');

class NewName {
  final String imageUrl;
  final String name;
  NewName(this.imageUrl, this.name);
}

Future<String> postAdd(NewName newName) async {
  final response = await http.post(
    apiUri.resolve('add'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'image_url': newName.imageUrl,
      'name': newName.name,
    }),
  );
  return jsonDecode(response.body)['id'];
}

class Name {
  final String id;
  final String imageUrl;
  final String name;
  Name.fromJson(Map<String, dynamic> json, this.id)
      : imageUrl = json['image_url'],
        name = json['name'];
}

Future<Name> getName(String id) async {
  final response = await http.get(apiUri.resolve(id));
  return Name.fromJson(jsonDecode(response.body), id);
}

Future<void> deleteName(String id) async {
  await http.delete(apiUri.resolve(id));
}

class All {
  final List<String> ids;
  All.fromJson(Map<String, dynamic> json)
      : ids = List<String>.from(json['ids']);
}

Future<All> getAll() async {
  final response = await http.get(apiUri.resolve('all'));
  return All.fromJson(jsonDecode(response.body));
}
