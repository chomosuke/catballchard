import 'package:flutter/material.dart';

class MFutureBuilder<T> extends StatelessWidget {
  final Future<T> _future;
  final Widget Function(BuildContext context, T data) _builder;
  const MFutureBuilder({
    Key? key,
    required Future<T> future,
    required Widget Function(BuildContext context, T data) builder,
  })  : _builder = builder,
        _future = future,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _builder(context, snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
