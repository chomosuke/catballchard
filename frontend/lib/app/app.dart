import 'scaffold.dart';
import 'package:frontend/helpers/future_builder.dart';
import 'package:flutter/material.dart';
import 'package:frontend/states/state.dart' as state;
import 'package:flutter_redux/flutter_redux.dart';

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
