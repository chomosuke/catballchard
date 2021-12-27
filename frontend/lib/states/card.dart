import 'package:frontend/http/all.dart' as http;
import 'package:frontend/states/section.dart';

class Card {
  final Future<String> id;
  final Future<CardData> data;
  final Section section;
  Card.get(String id, this.section)
      : data = (() async {
          final card = await http.getCard(id);
          return CardData(card.imageUrl, card.description);
        })(),
        id = Future.value(id);

  Card.post(String imageUrl, String description, this.section)
      : data = Future.value(CardData(imageUrl, description)),
        id = (() async => http.postCard(
              http.NewCard(imageUrl, description, await section.id),
            ))();

  Card.patch(
    Card previous,
    String? imageUrl,
    String? description,
    this.section,
  )   : data = (() async {
          await http.patchCard(
            http.CardPatch(imageUrl, description, await section.id),
            await previous.id,
          );
          return CardData(
            imageUrl ?? (await previous.data).imageUrl,
            description ?? (await previous.data).imageUrl,
          );
        })(),
        id = previous.id;

  Future<void> delete() async {
    await http.deleteCard(await id);
  }
}

class CardData {
  final String imageUrl;
  final String description;
  CardData(this.imageUrl, this.description);
}
