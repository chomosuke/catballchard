import 'package:flutter/foundation.dart';
import 'http/url.dart' hide All, Card;
import 'http/url.dart' as fetch show Card;
export 'http/url.dart' show NewCard;

class All extends ChangeNotifier {
  late Future<List<Future<Card>>> _all;
  All() {
    _all = (() async {
      final List<String> ids = (await getAll()).ids;
      return ids.map((id) => Card.get(id)).toList();
    })();
  }

  void add(NewCard newName) {
    final Future<Card> name = Card.post(newName);
    _all = (() async {
      // get the list from future
      final List<Future<Card>> all = await _all;
      // add to the list
      all.add(name);
      // return the list which will be wrapped in a future because async.
      return all;
    })();
    notifyListeners();
  }

  // name that's not in list is no-op to the list _all,
  // will still call delete on name
  void delete(Card name) {
    _all = (() async {
      // get the list from future
      final List<Future<Card>> all = await _all;
      var i = 0;
      while (i < all.length) {
        if (await all[i] == name) {
          break;
        }
        i++;
      }
      name.delete();
      if (i < all.length) {
        all.removeAt(i);
      }
      return all;
    })();
    notifyListeners();
  }

  Future<List<Future<Card>>> get all => _all;
}

class Card extends ChangeNotifier {
  String _id;
  String get id => _id;
  String _imageUrl;
  String get imageUrl => _imageUrl;
  String _name;
  String get name => _name;

  Card._plain(this._id, this._imageUrl, this._name);

  static Future<Card> get(String id) async {
    final fetch.Card nameData = await getCard(id);
    return Card._plain(nameData.id, nameData.imageUrl, nameData.description);
  }

  static Future<Card> post(NewCard newName) async {
    final String id = await postCard(newName);
    return Card._plain(id, newName.imageUrl, newName.description);
  }

  Future<void> delete() async {
    await deleteCard(_id);
  }
}
