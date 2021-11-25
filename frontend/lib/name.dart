import 'package:flutter/material.dart';
import 'lifecycle.dart' as lifecycle;

class Name extends StatefulWidget {
  final lifecycle.Name _name;
  const Name({Key? key, required lifecycle.Name name})
      : _name = name,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _NameState();
}

class _NameData {
  final String imageUrl;
  final String name;
  _NameData(this.imageUrl, this.name);
}

class _NameState extends State<Name> {
  late _NameData _name;
  void resetName() {
    setState(() {
      _name = _NameData(widget._name.imageUrl, widget._name.name);
    });
  }

  @override
  void initState() {
    super.initState();
    resetName();
    widget._name.addListener(resetName);
  }

  @override
  void dispose() {
    super.dispose();
    widget._name.removeListener(resetName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
                    alignment: Alignment.topCenter,
                    child: Image.network(_name.imageUrl))),
            SelectableText(_name.name)
          ],
        ));
  }
}
