import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/catballchard/catballchard.dart';
import 'package:provider/provider.dart';
import 'http/url.dart' show baseUrl;
import 'lifecycle.dart';

void main() {
  debugPaintSizeEnabled = true;
  runApp(
      ChangeNotifierProvider(create: (context) => All(), child: const App()));
}

// for dialog from everywhere
final _navigatorKey = GlobalKey<NavigatorState>();
BuildContext? getContext() => _navigatorKey.currentContext;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'CatBallChard',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Image.network(baseUrl.resolve('favicon.ico').toString()),
          title: const Text('CatBallChard'),
          leadingWidth: 56 / 210 * 240,
        ),
        body: const Catballchard(),
      ),
    );
  }
}
