import 'package:flutter/material.dart';
import 'name.dart';
import 'lifecycle.dart' as lifecycle;

class Grid extends StatelessWidget {
  final List<Future<lifecycle.Name>> _nameFutures;
  const Grid({Key? key, required List<Future<lifecycle.Name>> nameFutures})
      : _nameFutures = nameFutures,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 200,
      childAspectRatio: 9 / 10,
      crossAxisSpacing: 30,
      mainAxisSpacing: 30,
      children: _nameFutures
          .map<Widget>((name) => FutureBuilder<lifecycle.Name>(
                future: name,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Name(
                      name: snapshot.data!,
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ))
          .toList(),
    );
  }
}
