import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/actions/reducer.dart';
import 'package:frontend/catballchard/scaffold.dart';
import 'package:frontend/future_builder.dart';
import 'package:redux/redux.dart';
import 'package:frontend/states/state.dart' as state;

// for dialog from everywhere
final _navigatorKey = GlobalKey<NavigatorState>();
BuildContext? getContext() => _navigatorKey.currentContext;

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

class App extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const App({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'CatBallChard',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: MFutureBuilder<state.State>(
        future: StoreProvider.of<Future<state.State>>(context).state,
        builder: (context, data) => MScaffold(
          currentState: data,
        ),
      ),
    );
  }
}
