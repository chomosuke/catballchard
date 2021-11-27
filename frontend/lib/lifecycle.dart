import 'package:flutter/foundation.dart';
import 'fetch.dart' hide All, Name;
import 'fetch.dart' as fetch show Name;
export 'fetch.dart' show NewName;

class All extends ChangeNotifier {
  late Future<List<Future<Name>>> _all;
  All() {
    _all = (() async {
      final List<String> ids = (await getAll()).ids;
      return ids.map((id) => Name.get(id)).toList();
    })();
  }

  void add(NewName newName) {
    final Future<Name> name = Name.post(newName);
    _all = (() async {
      // get the list from future
      final List<Future<Name>> all = await _all;
      // add to the list
      all.add(name);
      // return the list which will be wrapped in a future because async.
      return all;
    })();
    notifyListeners();
  }

  // name that's not in list is no-op to the list _all,
  // will still call delete on name
  void delete(Name name) {
    _all = (() async {
      // get the list from future
      final List<Future<Name>> all = await _all;
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

  Future<List<Future<Name>>> get all => _all;
}

class Name extends ChangeNotifier {
  String _id;
  String get id => _id;
  String _imageUrl;
  String get imageUrl => _imageUrl;
  String _name;
  String get name => _name;

  Name._plain(this._id, this._imageUrl, this._name);

  static Future<Name> get(String id) async {
    final fetch.Name nameData = await getName(id);
    return Name._plain(nameData.id, nameData.imageUrl, nameData.name);
  }

  static Future<Name> post(NewName newName) async {
    final String id = await postAdd(newName);
    return Name._plain(id, newName.imageUrl, newName.name);
  }

  Future<void> delete() async {
    await deleteName(_id);
  }
}
