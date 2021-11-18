import 'package:catballchard_frontend/fetch.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _counter = 0;

  late Future<String> hello;
  @override
  void initState() {
    super.initState();
    hello = getHello();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.network(baseUri.resolve('favicon.ico').toString()),
        title: const Text('CatBallChard - A narcissistic personal website'),
        leadingWidth: 56 / 210 * 240,
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 100,
        children: <Widget>[
          FutureBuilder<String>(
            future: hello,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
