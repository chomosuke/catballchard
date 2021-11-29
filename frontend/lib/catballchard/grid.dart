import 'package:flutter/material.dart';
import 'package:frontend/future_builder.dart';
import 'new_name.dart';
import 'name.dart';
import '../lifecycle.dart' as lifecycle;

class Grid extends StatelessWidget {
  final List<Future<lifecycle.Name>> _nameFutures;
  const Grid({
    Key? key,
    required List<Future<lifecycle.Name>> nameFutures,
  })  : _nameFutures = nameFutures,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = _nameFutures
        .map<Widget>((name) => MFutureBuilder<lifecycle.Name>(
              future: name,
              builder: (context, data) => Name(
                name: data,
              ),
            ))
        .toList();
    children.add(const NewName());
    return GridView.extent(
      padding: const EdgeInsets.all(30),
      maxCrossAxisExtent: 182 * 2,
      // ^ should be double of the total width of buttons + all paddings
      childAspectRatio: 9 / 10,
      crossAxisSpacing: 30,
      mainAxisSpacing: 30,
      children: children,
    );
  }
}