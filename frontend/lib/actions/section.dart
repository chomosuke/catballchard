import 'package:frontend/actions/reducer.dart';
import 'package:frontend/states/state.dart';

class AddSection extends Action {
  final String name;
  AddSection(this.name);

  @override
  Future<State> act(Future<State> state) async {
    return State.addSection(await state, Section.post(name));
  }
}

class EditSection extends Action {
  final Section section;
  final String name;
  EditSection(this.section, this.name);

  @override
  Future<State> act(Future<State> state) async {
    return State.replaceSection(await state, Section.patch(section, name));
  }
}

class DeleteSection extends Action {
  final Section section;
  DeleteSection(this.section);

  @override
  Future<State> act(Future<State> state) async {
    section.delete();
    return State.removeSection(await state, section);
  }
}
