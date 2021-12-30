import 'package:frontend/http/all.dart' as http;
import 'section.dart';

export 'section.dart';
export 'card.dart';

class State {
  final Future<List<Section>> sections;
  final Future<String?> username;
  State.get()
      : sections = (() async {
          final all = await http.getAll();
          final sections = <Section>[];
          for (final sectionId in all.allSectionIds) {
            sections.add(
              Section.get(sectionId, all.ownedSectionIds.contains(sectionId)),
            );
          }
          return sections;
        })(),
        username = http.getUsername();

  Map<String, int>? _indexes;
  Future<Map<String, int>> get indexes async {
    if (_indexes == null) {
      _indexes = <String, int>{};
      final list = await sections;
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
        'section with sectionId: $id not found',
        'id',
      );
    }
    return index;
  }

  State.replaceSection(State previous, Section section)
      : sections = (() async {
          final index = await previous.getIndex(await section.id);
          final sections = (await previous.sections);
          sections[index] = section;
          return sections;
        })(),
        username = previous.username;

  State.addSection(State previous, Section section)
      : sections = (() async {
          final sections = (await previous.sections);
          sections.add(section);
          return sections;
        })(),
        username = previous.username;

  State.removeSection(State previous, Section section)
      : sections = (() async {
          final index = await previous.getIndex(await section.id);
          final sections = (await previous.sections);
          sections.removeAt(index);
          return sections;
        })(),
        username = previous.username;

  State.patchAccount(State previous, String? username, String? password)
      : sections = previous.sections,
        username = (() async {
          final success = await http.patchAccount(
            http.AccountPatch(username, password),
          );
          if (username != null && success) {
            return username;
          } else {
            return await previous.username;
          }
        })();
}
