import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget _child;
  const CardContainer(
      {Key? key, required Widget child, required double padding})
      : _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: _child,
    );
  }
}
