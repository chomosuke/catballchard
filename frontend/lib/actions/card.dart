import 'package:frontend/states/state.dart';
import 'reducer.dart';

class AddCard extends Action {
  final Section section;
  final String imageUrl;
  final String description;
  AddCard(this.imageUrl, this.description, this.section);

  @override
  Future<State> act(Future<State> state) async {
    final newCard = Card.post(imageUrl, description, section);
    final newSection = Section.addCard(section, newCard);
    return State.replaceSection(await state, newSection);
  }
}

class EditCard extends Action {
  final Card card;
  final String? imageUrl;
  final String? description;
  EditCard(
    this.card, {
    this.imageUrl,
    this.description,
  });

  @override
  Future<State> act(Future<State> state) async {
    final newCard = Card.patch(card, imageUrl, description, card.section);
    final newSection = Section.replaceCard(card.section, newCard);
    return State.replaceSection(await state, newSection);
  }
}

class DeleteCard extends Action {
  final Card card;
  DeleteCard(this.card);

  @override
  Future<State> act(Future<State> state) async {
    await card.delete();
    return State.replaceSection(
      await state,
      Section.removeCard(card.section, card),
    );
  }
}
