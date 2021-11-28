import 'package:flutter/material.dart';
import '../card_container.dart';
import 'package:provider/provider.dart';
import '../lifecycle.dart' as lifecycle;

class Name extends StatefulWidget {
  final lifecycle.Name _name;
  const Name({Key? key, required lifecycle.Name name})
      : _name = name,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _NameState();
}

class _NameState extends State<Name> {
  void markNeedsBuild() => setState(() {});

  @override
  void initState() {
    super.initState();
    widget._name.addListener(markNeedsBuild);
  }

  @override
  void dispose() {
    super.dispose();
    widget._name.removeListener(markNeedsBuild);
  }

  @override
  Widget build(BuildContext context) {
    void onDelete() {
      Provider.of<lifecycle.All>(context, listen: false).delete(widget._name);
    }

    final card = CardContainer(
      padding: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Image.network(
                    widget._name.imageUrl,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
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
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: SelectableText(
              widget._name.name,
              style: const TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );

    final dialog = GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Image.network(
              widget._name.imageUrl,
              filterQuality: FilterQuality.medium,
            ),
          ),
          SelectableText(
            widget._name.name,
            style: const TextStyle(
              fontSize: 32,
              backgroundColor: Color.fromARGB(150, 150, 150, 150),
            ),
          ),
        ],
      ),
    );

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => dialog,
        );
      },
      child: card,
    );
  }
}
