import 'fetch.dart' hide All, Name;
import 'fetch.dart' as fetch show Name;
export 'fetch.dart' show NewName;

class All {
  Future<List<Future<Name>>> _all;
  final void Function(void Function() fn) _setState;
  All(this._setState)
      : _all = (() async {
          final List<String> ids = (await getAll()).ids;
          return ids.map((id) => Name.get(id)).toList();
        })();

  void add(NewName newName) {
    final Future<Name> name = Name.post(newName);
    _setState(() {
      _all = (() async {
        final List<Future<Name>> all = await _all;
        all.add(name);
        return all;
      })();
    });
  }

  Future<List<Future<Name>>> get all {
    return _all;
  }
}

class Name {
  String id;
  String imageUrl;
  String name;

  Name._plain(this.id, this.imageUrl, this.name);

  static Future<Name> get(String id) async {
    final fetch.Name nameData = await getName(id);
    return Name._plain(nameData.id, nameData.imageUrl, nameData.name);
  }

  static Future<Name> post(NewName newName) async {
    final String id = await postAdd(newName);
    return Name._plain(id, newName.imageUrl, newName.name);
  }
}
