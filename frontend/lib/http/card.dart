import 'dart:convert';
import 'package:http_status_code/http_status_code.dart';
import 'status_code_handling.dart';
import 'url.dart';
import 'package:http/http.dart' as http;

class NewCard {
  final String imageUrl;
  final String description;
  final String sectionId;
  NewCard(this.imageUrl, this.description, this.sectionId);
  toReq() {
    return <String, String>{
      'image_url': imageUrl,
      'description': description,
      'section_id': sectionId,
    };
  }
}

Future<String> postCard(NewCard newCard) async {
  final response = await http.post(
    apiUrl.resolve('card'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(newCard.toReq()),
  );
  if (response.statusCode != StatusCode.OK) {
    throw StatusCodeException(response.statusCode);
  }
  return jsonDecode(response.body)['id'];
}

class Card {
  final String id;
  final String imageUrl;
  final String description;
  final String sectionId;
  Card.fromRes(Map<String, dynamic> res, this.id)
      : imageUrl = res['image_url'],
        description = res['description'],
        sectionId = res['section_id'];
}

Future<Card> getCard(String id) async {
  final response = await http.get(apiUrl.resolve('card/$id'));
  if (response.statusCode != StatusCode.OK) {
    throw StatusCodeException(response.statusCode);
  }
  return Card.fromRes(jsonDecode(response.body), id);
}

class CardPatch {
  final String? imageUrl;
  final String? description;
  final String? sectionId;
  CardPatch(this.imageUrl, this.description, this.sectionId);
  toReq() {
    final req = <String, String>{};
    if (imageUrl != null) {
      req['image_url'] = imageUrl!;
    }
    if (description != null) {
      req['description'] = description!;
    }
    if (sectionId != null) {
      req['section_id'] = sectionId!;
    }
    return req;
  }
}

Future<void> patchCard(CardPatch cardPatch, String id) async {
  final response = await http.patch(
    apiUrl.resolve('card/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(cardPatch.toReq()),
  );
  if (response.statusCode != StatusCode.OK) {
    throw StatusCodeException(response.statusCode);
  }
}

Future<void> deleteCard(String id) async {
  final response = await http.delete(apiUrl.resolve('card/$id'));
  if (response.statusCode != StatusCode.OK) {
    throw StatusCodeException(response.statusCode);
  }
}
