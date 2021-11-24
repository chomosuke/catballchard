import 'package:flutter/material.dart';
import 'lifecycle.dart' as lifecycle;

class Name extends StatelessWidget {
  final lifecycle.Name _name;
  const Name({Key? key, required lifecycle.Name name})
      : _name = name,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(_name.id);
  }
}
