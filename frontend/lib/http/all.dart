import 'dart:convert';
import 'package:frontend/http/status_code_handling.dart';

import 'url.dart';
import 'package:http/http.dart' as http;

class All {
  late final List<String> otherSectionIds;
  late final List<String> ownedSectionIds;
  All.fromRes(Map<String, dynamic> allRes, Map<String, dynamic> ownedRes) {
    final allIds = List<String>.from(allRes['ids']);
    ownedSectionIds = List<String>.from(ownedRes['ids']);
    final allSet = Set.from(allIds);
    final ownedSet = Set.from(ownedSectionIds);
    otherSectionIds = List.from(allSet.difference(ownedSet));
  }
}

Future<All> getAll() async {
  final responses = await Future.wait([
    http.get(apiUrl.resolve('section/all')),
    http.get(apiUrl.resolve('section/owned')),
  ]);
  for (final response in responses) {
    if (response.statusCode != 200) {
      throw StatusCodeException(200);
    }
  }
  return All.fromRes(
    jsonDecode(responses[0].body),
    jsonDecode(responses[1].body),
  );
}
