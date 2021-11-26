import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/future_builder.dart';
import 'package:provider/provider.dart';
import 'fetch.dart' show baseUri;
import 'grid.dart';
import 'lifecycle.dart';

void main() {
  debugPaintSizeEnabled = true;
  runApp(
      ChangeNotifierProvider(create: (context) => All(), child: const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

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
        body: Consumer<All>(
            builder: (context, all, child) =>
                MFutureBuilder<List<Future<Name>>>(
                    future: all.all,
                    builder: (context, data) => Grid(
                          nameFutures: data,
                        ))),
      ),
    );
  }
}
