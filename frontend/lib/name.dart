import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    void onDelete() {
      Provider.of<lifecycle.All>(context, listen: false).delete(widget._name);
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Image.network(_name.imageUrl),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(150, 150, 150, 150),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: IconButton(
                    onPressed: onDelete,
                    padding: const EdgeInsets.all(0),
                    iconSize: 32,
                    icon: const Icon(Icons.delete_forever_outlined),
                  ),
                ),
              ],
            ),
          ),
          SelectableText(_name.name)
        ],
      ),
    );
  }
}
