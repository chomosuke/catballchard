import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/actions/reducer.dart';
import 'package:frontend/app/app.dart';
import 'package:redux/redux.dart';
import 'package:frontend/states/state.dart' as state;

// for dialog from everywhere
final _navigatorKey = GlobalKey<NavigatorState>();
BuildContext? getContext() => _navigatorKey.currentContext;

final storage = const FlutterSecureStorage();

void main() {
  debugPaintSizeEnabled = true;
  final store = Store<Future<state.State>>(
    (state, action) => reducer(state, action),
    initialState: Future.value(state.State.get()),
  );
  runApp(StoreProvider<Future<state.State>>(
    store: store,
    child: App(navigatorKey: _navigatorKey),
  ));
}
