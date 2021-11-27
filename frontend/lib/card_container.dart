import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget _child;
  final double _padding;
  const CardContainer(
      {Key? key, required Widget child, required double padding})
      : _child = child,
        _padding = padding,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: _child,
    );
  }
}
