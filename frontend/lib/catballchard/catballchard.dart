import 'package:flutter/material.dart';
import 'package:frontend/future_builder.dart';
import 'package:frontend/catballchard/grid.dart';
import 'package:frontend/lifecycle.dart';
import 'package:provider/provider.dart';

class Catballchard extends StatelessWidget {
  const Catballchard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<All>(
      builder: (context, all, child) => MFutureBuilder<List<Future<Card>>>(
        future: all.all,
        builder: (context, data) => Grid(
          nameFutures: data,
        ),
      ),
    );
  }
}
