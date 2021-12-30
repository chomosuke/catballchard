import 'package:flutter/material.dart';

class MFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final bool alwaysShowLoading;
  const MFutureBuilder({
    Key? key,
    required this.future,
    required this.builder,
    this.alwaysShowLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_Wrap<T>>(
      future: (() async => _Wrap(await future))(),
      builder: (context, snapshot) {
        if (alwaysShowLoading
            ? snapshot.connectionState == ConnectionState.done
            : snapshot.hasData) {
          return builder(context, snapshot.data!.content);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

// this is for the future that return null
class _Wrap<T> {
  final T content;
  _Wrap(this.content);
}
