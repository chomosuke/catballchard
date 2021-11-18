import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'main_page.dart';

void main() {
  debugPaintSizeEnabled = true;
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CatBallChard',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: const MainPage());
  }
}
