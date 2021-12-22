import 'dart:convert';
import 'package:frontend/http/status_code_handling.dart';

import 'url.dart';
import 'package:http/http.dart' as http;

class NewSection {
  final String name;
  NewSection(this.name);
  toReq() {
    return <String, String>{
      'name': name,
    };
  }
}

Future<String> postSection(NewSection newSection) async {
  final response = await http.post(
    apiUrl.resolve('section'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(newSection.toReq()),
  );
  if (response.statusCode != 200) {
    throw StatusCodeException(200);
  }
  return jsonDecode(response.body)['id'];
}

class Section {
  final String id;
  final String name;
  final List<String> cardIds;
  Section.fromRes(Map<String, dynamic> res, this.id)
      : name = res['name'],
        cardIds = List<String>.from(res['card_ids']);
}

Future<Section> getSection(String id) async {
  final response = await http.get(apiUrl.resolve('section/$id'));
  if (response.statusCode != 200) {
    throw StatusCodeException(200);
  }
  return Section.fromRes(jsonDecode(response.body), id);
}

class SectionPatch {
  final String name;
  SectionPatch(this.name);
  toReq() {
    return <String, String>{
      'name': name,
    };
  }
}

Future<void> patchSection(SectionPatch sectionPatch, String id) async {
  final response = await http.post(
    apiUrl.resolve('section/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(sectionPatch.toReq()),
  );
  if (response.statusCode != 200) {
    throw StatusCodeException(200);
  }
}

Future<void> deleteSection(String id) async {
  final response = await http.delete(apiUrl.resolve('section/$id'));
  if (response.statusCode != 200) {
    throw StatusCodeException(200);
  }
}