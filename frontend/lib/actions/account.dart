import 'package:frontend/http/all.dart';
import 'reducer.dart';
import 'package:frontend/states/state.dart';

class Login extends Action {
  final String username;
  final String password;
  Login(this.username, this.password);

  @override
  Future<State> act(Future<State> state) async {
    final success = await login(AccountPost(username, password));
    if (success) {
      return State.get();
    } else {
      return state;
    }
  }
}

class Logout extends Action {
  @override
  Future<State> act(Future<State> state) async {
    await logout();
    return State.get();
  }
}

class Register extends Action {
  final String username;
  final String password;
  Register(this.username, this.password);

  @override
  Future<State> act(Future<State> state) async {
    final success = await register(AccountPost(username, password));
    if (success) {
      return State.get();
    } else {
      return state;
    }
  }
}

class AccountPatch extends Action {
  final String? username;
  final String? password;
  AccountPatch({this.username, this.password});

  @override
  Future<State> act(Future<State> state) async {
    return State.patchAccount(await state, username, password);
  }
}
