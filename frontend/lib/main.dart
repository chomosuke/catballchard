import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'fetch.dart' show baseUri;
import 'grid.dart';
import 'lifecycle.dart';

void main() {
  debugPaintSizeEnabled = true;
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late All _all;

  @override
  void initState() {
    super.initState();
    _all = All(setState);
  }

  void _addDefaultName() {
    _all.add(
        NewName(baseUri.resolve('favicon.ico').toString(), 'catballchard'));
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
        body: FutureBuilder<List<Future<Name>>>(
          future: _all.all,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Grid(nameFutures: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addDefaultName,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
