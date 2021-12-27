import 'dart:convert';
import 'status_code_handling.dart';
import 'package:http_status_code/http_status_code.dart';
import 'url.dart';
import 'package:http/http.dart' as http;

export 'account.dart';
export 'card.dart';
export 'section.dart';

class All {
  late final List<String> allSectionIds;
  late final Set<String> ownedSectionIds;
  All.fromRes(
    Map<String, dynamic> allRes,
    Map<String, dynamic> ownedRes,
  ) {
    allSectionIds = List<String>.from(allRes['ids']);
    ownedSectionIds = Set<String>.from(ownedRes['ids']);
  }
}

Future<All> getAll() async {
  final responses = await Future.wait([
    http.get(apiUrl.resolve('section/all')),
    http.get(apiUrl.resolve('section/owned')),
  ]);
  if (responses[0].statusCode != StatusCode.OK) {
    throw StatusCodeError(responses[0].statusCode);
  }
  if (responses[1].statusCode == StatusCode.OK) {
    return All.fromRes(
      jsonDecode(responses[0].body),
      jsonDecode(responses[1].body),
    );
  } else if (responses[1].statusCode == StatusCode.UNAUTHORIZED) {
    return All.fromRes(
      jsonDecode(responses[0].body),
      <String, dynamic>{'ids': []},
    );
  } else {
    throw StatusCodeError(responses[1].statusCode);
  }
}
