import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/fetch.dart';

void main() {
  debugPaintSizeEnabled = true;
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  void _addDefaultName() {
    postAdd(NewName(baseUri.resolve('favicon.ico').toString(), 'catballchard'));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatBallChard',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Image.network(baseUri.resolve('favicon.ico').toString()),
          title: const Text('CatBallChard'),
          leadingWidth: 56 / 210 * 240,
        ),
        body: const Text('hi'),
        floatingActionButton: FloatingActionButton(
          onPressed: _addDefaultName,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
