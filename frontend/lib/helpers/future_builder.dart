import 'package:flutter/material.dart';

class MFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data)? builder;
  final Widget Function(BuildContext context, T? data)? nullableBuilder;
  MFutureBuilder({
    Key? key,
    required this.future,
    this.builder,
    this.nullableBuilder,
  }) : super(key: key) {
    if (null is T) {
      assert(builder == null && nullableBuilder != null);
    } else {
      assert(builder != null && nullableBuilder == null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done ||
            snapshot.hasData) {
          if (builder != null) {
            return builder!(context, snapshot.data!);
          } else {
            return nullableBuilder!(context, snapshot.data);
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
