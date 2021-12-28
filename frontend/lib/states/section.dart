import 'package:frontend/http/all.dart' as http;

import 'card.dart';

class Section {
  final Future<String> id;
  final bool owned;
  late final Future<SectionData> data;
  Section.get(String id, this.owned) : id = Future.value(id) {
    data = (() async {
      final section = await http.getSection(id);
      final cards = <Card>[];
      for (final cardId in section.cardIds) {
        cards.add(Card.get(cardId, this));
      }
      return SectionData(section.name, cards);
    })();
  }

  Map<String, int>? _indexes;
  Future<Map<String, int>> get indexes async {
    if (_indexes == null) {
      _indexes = <String, int>{};
      final list = (await data).cards;
      for (int i = 0; i < list.length; i++) {
        _indexes![await list[i].id] = i;
      }
    }
    return _indexes!;
  }

  Future<int> getIndex(String id) async {
    final index = (await indexes)[id];
    if (index == null) {
      throw ArgumentError(
        'card with cardId: $id not found',
        'id',
      );
    }
    return index;
  }

  Section.replaceCard(Section previous, Card card)
      : id = previous.id,
        owned = previous.owned,
        data = (() async {
          final data = await previous.data;
          final cards = data.cards;
          final index = await previous.getIndex(await card.id);
          cards[index] = card;
          return SectionData(data.name, cards);
        })();

  Section.addCard(Section previous, Card card)
      : id = previous.id,
        owned = previous.owned,
        data = (() async {
          final data = await previous.data;
          final cards = data.cards;
          cards.add(card);
          return SectionData(data.name, cards);
        })();

  Section.removeCard(Section previous, Card card)
      : id = previous.id,
        owned = previous.owned,
        data = (() async {
          final data = await previous.data;
          final cards = data.cards;
          final index = await previous.getIndex(await card.id);
          cards.removeAt(index);
          return SectionData(data.name, cards);
        })();

  Section.post(String name)
      : data = Future.value(SectionData(name, [])),
        owned = true,
        id = http.postSection(http.NewSection(name));

  Section.patch(Section previous, String name)
      : data = (() async => SectionData(name, (await previous.data).cards))(),
        owned = previous.owned,
        id = previous.id;

  Future<void> delete() async {
    await http.deleteSection(await id);
  }
}

class SectionData {
  final String name;
  final List<Card> cards;
  SectionData(this.name, this.cards);
}
