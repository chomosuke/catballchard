import 'package:frontend/states/state.dart';
export 'account.dart';
export 'card.dart';
export 'section.dart';

Future<State> reducer(Future<State> state, Action action) => action.act(state);

abstract class Action {
  Future<State> act(Future<State> state);
}
